import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technician/constans.dart';
import 'package:http/http.dart' as http;

final _foregroundServiceAndroidConfig = AndroidConfiguration(
  onStart: _onStart,
  autoStart: false,
  isForegroundMode: true,
  foregroundServiceNotificationId: kLocationServiceNotificationId,
  notificationChannelId: kLocationServiceChannel.id,
  initialNotificationTitle: 'Location Service',
  initialNotificationContent: 'Running',
  autoStartOnBoot: false,
);

final _foregroundServiceIosConfig = IosConfiguration(
  autoStart: false,
  onForeground: _onStart,
);

const _stopKey = 'stop';

class LocationService {
  static final _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final _foregroundService = FlutterBackgroundService();

  static Future<void> initialize() async {
    await _flutterLocalNotificationsPlugin
        .initialize(kFlutterLocalNotificationSettings);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(kLocationServiceChannel);

    await _foregroundService.configure(
      androidConfiguration: _foregroundServiceAndroidConfig,
      iosConfiguration: _foregroundServiceIosConfig,
    );
  }

  static Future<bool> get isPermissionsGranted async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return false;
    }

    final status = await Permission.notification.request();
    if (status != PermissionStatus.granted) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission != LocationPermission.always) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      if (permission == LocationPermission.denied) {
        return false;
      }
      if (permission == LocationPermission.whileInUse) {
        return false;
      }
    }
    return true;
  }

  static Future<void> start() async {
    await _foregroundService.startService();
  }

  static Future<void> stop() async {
    if (!await isServiceRunning) return;
    _foregroundService.invoke(_stopKey);
  }

  static Future<bool> get isServiceRunning => _foregroundService.isRunning();
}

@pragma('vm:entry-point')
void _onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  service as AndroidServiceInstance;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final timer = Timer.periodic(
    const Duration(seconds: 5),
    (_) async {
      final position = await Geolocator.getCurrentPosition();

      _sendToApi(position);
      final text =
          '${position.latitude.toString()}, ${position.longitude.toString()}';
      print(text);

      flutterLocalNotificationsPlugin.show(
        kLocationServiceNotificationId,
        'Location Service',
        'User Location$text',
        NotificationDetails(
          android: AndroidNotificationDetails(
            kLocationServiceChannel.id,
            kLocationServiceChannel.name,
            ongoing: true,
          ),
        ),
      );
    },
  );

  service.on(_stopKey).listen((_) {
    timer.cancel();
    service.stopSelf();
  });
}

Future<void> _sendToApi(Position position) async {
  try {
    final url =
        Uri.parse('https://s1.lianerp.com/api/public/provider/log-location');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString('token');
    final _ip = prefs.getString('ip');
    final _cellNumber = prefs.getString('cellNumber');
    final _userAgent = prefs.getString('userAgent');

    final headers = {
      'Tokenpublic': 'bpbm',
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'ip': _ip,
      'phone_number': _cellNumber,
      'userAgent': _userAgent,
      'lat': position.latitude,
      'lng': position.longitude,
      'token': _token,
    });

    final response = await http.post(url, headers: headers, body: body);
    print('Your API response is ${response.body}');
    print(body);
    print('cellNumber');
    print('Your response code is ${response.statusCode}');
  } catch (e) {}
}
