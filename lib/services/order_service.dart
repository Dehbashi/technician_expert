import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  Future<List<Order>> getOrders() async {
    final url =
        Uri.parse('https://s1.lianerp.com/api/public/provider/order/list');

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
    print(response);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> data = jsonData['data']['data'];
      print(jsonData);

      if (data.isNotEmpty) {
        final List<Order> orders = data
            .map((item) => Order.fromJson(item as Map<String, dynamic>))
            .toList();
        print('Your orders are $orders');

        return orders;
      } else {
        print('No orders found');
        return []; // Return an empty list if no orders found
      }
    } else {
      throw Exception('Failed to load orders');
    }
  }
}

class Order {
  final int id;
  final String service;
  final int order_status;
  final String created_at;

  Order(
      {required this.id,
      required this.service,
      required this.order_status,
      required this.created_at});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["id"],
      service: json["service"],
      order_status: json["order_status"],
      created_at: json["created_at"],
    );
  }
}
