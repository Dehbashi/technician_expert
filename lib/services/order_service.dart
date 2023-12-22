import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderService {
  Future<List<Order>> getOrders() async {
    final url = Uri.parse('https://your-api-url.com/orders');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Order> orders =
          data.map((item) => Order.fromJson(item)).toList();
      return orders;
    } else {
      throw Exception('Failed to load orders');
    }
  }
}

class Order {
  final int id;
  final String name;
  final String details;

  Order({required this.id, required this.name, required this.details});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      name: json['name'],
      details: json['details'],
    );
  }
}
