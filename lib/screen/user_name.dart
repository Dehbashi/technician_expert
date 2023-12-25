import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technician/screen/admin_page.dart';
import './header.dart';
import './widget/textFieldWidget.dart';
import './widget/buttonWidget.dart';

class UserName extends StatefulWidget {
  const UserName({super.key});

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  final _formKey = GlobalKey<FormState>();
  late String firstName = '';
  late String lastName = '';

  Future<void> SaveName(String firstName, String lastName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', firstName);
    prefs.setString('lastName', lastName);
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
                    'ورود نام و نام خانوادگی',
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
                              keyboardType: TextInputType.name,
                              onSaved: (value) {
                                firstName =
                                    value ?? ''; // Save the cellNumber value
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'لطفاً نام خود را وارد نمایید';
                                }
                                return null;
                              },
                              icon: null,
                              labelText: 'نام',
                              obscureText: false,
                              suffixIcon: null,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                            child: TextFieldWidget(
                              keyboardType: TextInputType.name,
                              onSaved: (value) {
                                lastName =
                                    value ?? ''; // Save the cellNumber value
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'لطفاً نام خانوادگی خود را وارد نمایید';
                                }
                                return null;
                              },
                              icon: null,
                              labelText: 'نام خانوادگی',
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
                                SaveName(firstName, lastName);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminPage(),
                                  ),
                                );
                              }
                              print('Your first name is: $firstName');
                              print('Your last name is: $lastName');
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
  }
}
