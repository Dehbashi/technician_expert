import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
// import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      // _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  // Future<void> _getAddressFromLatLng(Position position) async {
  //   final Uri url = Uri.parse(
  //     'https://api.neshan.org/v5/reverse?lat=35.7574069&lng=51.2219016',
  //     // 'https://neshan.org/maps/@35.7574069,51.2219016,15.2z,0p',
  //   );
  //   if (!await launchUrl(url)) {
  //     throw Exception('Could not launch');
  //   }

  //   final response = await http.get(
  //     url,
  //     headers: {'Api-Key': 'service.5d9ec16927944d3d811e927813e82979'},
  //   );
  //   if (response.statusCode == 200) {
  //     final responseData = json.decode(response.body);
  //     final address = responseData['address'];
  //     setState(() {
  //       _currentAddress =
  //           '${address['street']}, ${address['subLocality']}, ${address['subAdministrativeArea']}, ${address['postalCode']}';
  //     });
  //   } else {
  //     debugPrint('Request failed with status:');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Page")),
      body: Column(
        children: [
          Container(
            height: 600,
            width: double.infinity,
            alignment: Alignment.center,
            child: FlutterMap(
              options: MapOptions(
                // initialCenter: LatLng(2, 7),
                initialZoom: 15,
                initialCenter: latLng.LatLng(
                  _currentPosition?.latitude ?? 35.7006381,
                  _currentPosition?.longitude ?? 51.4089094,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                // CurrentLocationLayer(
                //   followOnLocationUpdate: FollowOnLocationUpdate.always,
                //   turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
                //   style: LocationMarkerStyle(
                //     marker: const DefaultLocationMarker(
                //       child: Icon(
                //         Icons.navigation,
                //         color: Colors.white,
                //       ),
                //     ),
                //     markerSize: const Size(30, 30),
                //     markerDirection: MarkerDirection.heading,
                //   ),
                // ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright')),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              'Live Location',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.blue,
              ),
            ),
          ),
          // SafeArea(
          //   child: Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text('LAT: ${_currentPosition?.latitude ?? ""}'),
          //         Text('LNG: ${_currentPosition?.longitude ?? ""}'),
          //         Text('ADDRESS: ${_currentAddress ?? ""}'),
          //         const SizedBox(height: 32),
          //         ElevatedButton(
          //           onPressed: _getCurrentPosition,
          //           child: const Text("Get Current Location"),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
