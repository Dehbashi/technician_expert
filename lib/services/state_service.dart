import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StateService {
  // const StateService({super.key});
  final int status;
  final int id;

  StateService({required this.status, required this.id});

  Future<void> getStatus() async {
    final url = Uri.parse(
        'https://s1.lianerp.com/api/public/provider/order/change-status');

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

    final body = {
      'status': status,
      'id': id,
    };

    final encodedBody = jsonEncode(body);

    final response = await http.post(
      url,
      headers: headers,
      body: encodedBody,
    );
    print(response);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print('Your json data is $jsonData');
    } else {
      throw Exception(
          'Failed to load orders with error ${response.statusCode}');
    }
  }
}
