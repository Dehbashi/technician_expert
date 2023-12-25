import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderDetailsFetch {
  Future<OrderDetails?> getOrderDetails(int id) async {
    final url = Uri.parse(
        'https://s1.lianerp.com/api/public/provider/order/show?id=$id');
    // final url =
    //     Uri.parse('https://s1.lianerp.com/api/public/provider/order/show');

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

    final response = await http.get(
      url,
      headers: headers,
    );
    print('Your order details are ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final dynamic data = jsonData['data']['order'];
      print(jsonData);

      if (data != null) {
        final OrderDetails orderDetails =
            OrderDetails.fromJson(data as Map<String, dynamic>);
        print('Your order details data are ${orderDetails.address}');

        return orderDetails;
      } else {
        print('No orders found');
        return null; // Return an empty list if no orders found
      }
    } else {
      throw Exception(
          'Failed to load orders with error ${response.statusCode}');
    }
  }
}

class OrderDetails {
  final int id;
  final int userId;
  final int priceServices;
  final String priceProduct;
  final String transportationCost;
  final String totalPrice;
  final String date;
  final String time;
  final int status;
  final int orderStatus;
  final List items;
  final dynamic address;
  final dynamic service;
  final dynamic user;

  OrderDetails({
    required this.id,
    required this.userId,
    required this.priceServices,
    required this.priceProduct,
    required this.transportationCost,
    required this.totalPrice,
    required this.date,
    required this.time,
    required this.status,
    required this.orderStatus,
    required this.items,
    required this.address,
    required this.service,
    required this.user,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      id: json["id"],
      userId: json["user_id"],
      priceServices: json["price_services"],
      priceProduct: json["price_products"],
      transportationCost: json["transportationcost"],
      totalPrice: json["totalprice"],
      date: json["date"],
      time: json["time"],
      status: json["status"],
      orderStatus: json["order_status"],
      items: json["items"],
      address: json["address"],
      service: json["service"],
      user: json["user"],
    );
  }
}
