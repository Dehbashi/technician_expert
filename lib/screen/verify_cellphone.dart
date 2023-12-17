import 'package:flutter/material.dart';
import './admin_page.dart';
import './enter_cellphone.dart';
import './header.dart';
import './widget/buttonWidget.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CellVerification extends StatefulWidget {
  // const CellVerification({super.key});

  final String cellNumber;
  final String ip;
  final String userAgent;

  CellVerification({
    required this.cellNumber,
    required this.ip,
    required this.userAgent,
  });

  @override
  State<CellVerification> createState() => _CellVerificationState();
}

class _CellVerificationState extends State<CellVerification> {
  late String otpCode;
  late String cellNumber = widget.cellNumber;
  late String ip = widget.ip;
  late String userAgent = widget.userAgent;

  Future<void> verifyOtpCode(
      String ip, String cellNumber, String userAgent, String otpCode) async {
    final url = Uri.parse('https://s1.neshan.com/api/public/auth/otp/verify');

    final headers = {
      'TokenPublic': 'bpbm',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'ip': ip,
      'phone_number': cellNumber,
      'userAgent': userAgent,
      'code': otpCode,
    });

    final response = await http.post(url, headers: headers, body: body);
    print(response.body);
    print(body);
    print('cellNumber');
    print(cellNumber);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['data']['token'];
      final id = data['data']['user']['id'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      prefs.setInt('id', id);
      prefs.setString('cellNumber', cellNumber);
      prefs.setString('userAgent', userAgent);

      print('your data is $data');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Failed to send phone number with ${response.statusCode}'),
        ),
      );
    }
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
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    'کد تأیید',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    padding: EdgeInsets.only(right: 40, left: 30),
                    alignment: Alignment.topRight,
                    child: Text(
                      'کد تأیید برای شما ارسال شد. لطفاً آن را در کادر زیر وارد نمایید.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Container(
                  child: OtpTextField(
                    numberOfFields: 5,
                    borderColor: Color(0xFF512DA8),
                    //set to true to show as box or false to show as dash
                    showFieldAsBox: true,
                    //runs when a code is typed in
                    onCodeChanged: (String code) {
                      //handle validation or checks here
                    },
                    //runs when every textfield is filled
                    onSubmit: (String verificationCode) {
                      otpCode = verificationCode;
                    }, // end onSubmit
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  margin: EdgeInsets.only(top: 15),
                  child: GestureDetector(
                    onTap: () {
                      print('Verification code is: $otpCode');
                      verifyOtpCode(ip, cellNumber, userAgent, otpCode);
                    },
                    child: ButtonWidget(
                      title: 'تأیید کد',
                      hasBorder: false,
                    ),
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  margin: EdgeInsets.only(top: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: ButtonWidget(
                      title: 'بازگشت',
                      hasBorder: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
