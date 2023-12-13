import 'package:flutter/material.dart';
import './header.dart';
import './verify_cellphone.dart';
import './widget/textFieldWidget.dart';
import 'widget/buttonWidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_ip_address/get_ip_address.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './widget/get_user_agent.dart';

class CellEnter extends StatefulWidget {
  const CellEnter({super.key});

  @override
  State<CellEnter> createState() => _CellEnterState();
}

class _CellEnterState extends State<CellEnter> {
  final _formKey = GlobalKey<FormState>();
  late String cellNumber;
  late String mainOtpCode;
  late String mainIpAddress;
  late String _userAgent = 'unknown';

  /// Code for fetching the user agent of the device
  ///
  Future<void> saveUserAgent() async {
    late String? userAgent;
    try {
      userAgent = await GetUserAgent.getUserAgent();
    } on PlatformException catch (e) {
      print('Failed to get user agent: ${e.message}');
    }

    if (userAgent != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userAgent', userAgent);
    }

    setState(() {
      _userAgent = userAgent!;
    });
  }

  /// Finish Code for fetching the user agent of the device

  void getIP() async {
    try {
      var ipAddress = IpAddress(type: RequestType.json);
      dynamic data = await ipAddress.getIpAddress();
      String ipAddressString = data['ip'];
      mainIpAddress = ipAddressString;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('ip', mainIpAddress);
    } on IpAddressException catch (exception) {
      print(exception.message);
    }
  }

  /// Finish Code for fetching the IP of the device

  Future<void> sendPhoneNumber(
      String mainIpAddress, String cellNumber, String platformVersion) async {
    final url = Uri.parse('https://s1.lianerp.com/api/public/auth/otp/send');
    // final url = Uri.parse('https://s1.lianerp.com/api/public/auth/otp/verify');

    final headers = {
      'TokenPublic': 'bpbm',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'ip': mainIpAddress,
      'phone_number': cellNumber,
      'userAgent': platformVersion,
      // 'code': 18395,
    });

    final response = await http.post(url, headers: headers, body: body);
    print(response.body);
    print('cellNumber');
    print(cellNumber);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // setState(() {
      //   mainOtpCode = data['otp'];
      // });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Failed to send phone number with ${response.statusCode}'),
        ),
      );
    }
  }

  /// Finish Sending the information to receive OTP
  ///
  ///
  ///
  @override
  void initState() {
    super.initState();
    saveUserAgent();
    getIP();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Header(),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // UserAgent(),
                Container(
                  alignment: Alignment.center,
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF9BDCE0),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    'ورود به سامانه موقعیت یاب',
                    style: TextStyle(
                      fontFamily: 'iranSans',
                      color: Color(0xFF037E85),
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                            child: TextFieldWidget(
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                cellNumber =
                                    value ?? ''; // Save the cellNumber value
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'لطفاً شماره تلفن خود را وارد نمایید';
                                } else if (!value.startsWith('09')) {
                                  return 'شماره تلفن باید با 09 آغاز شود';
                                } else if (value.length != 11) {
                                  return 'شماره تلفن باید 11 رقمی باشد';
                                }
                                return null;
                              },
                              icon: Icons.phone,
                              labelText: 'شماره تلفن',
                              obscureText: false,
                              suffixIcon: null,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                sendPhoneNumber(
                                  mainIpAddress,
                                  cellNumber,
                                  _userAgent,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CellVerification(
                                      ip: mainIpAddress,
                                      cellNumber: cellNumber,
                                      userAgent: _userAgent,
                                    ),
                                  ),
                                );
                              }
                              print('Your phone number is: $cellNumber');
                              print('Your IP Address is: $mainIpAddress');
                              print('Your User Agent is: $_userAgent');
                            },
                            child: ButtonWidget(
                              title: 'ورود',
                              hasBorder: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
