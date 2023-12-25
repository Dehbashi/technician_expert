import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technician/services/location_service.dart';
import 'package:technician/services/order_details.dart';
import 'dart:async';
import './logout_page.dart';
import 'package:persian/persian.dart';
import './header.dart';
import '../constans.dart';
import '../services/order_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'order_state_buttons.dart';

class AdminPage extends StatefulWidget {
  // const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  String text = "Start Service";
  late String _cellNumber = '';
  late String _firstName = '';
  late String _lastName = '';
  List<Order> orders = [];
  bool expanded = false;
  // List<OrderDetails> orderDetails = [];
  List<OrderDetails?> orderDetails = [];

  void initState() {
    _getDeviceInformation();
    fetchOrders();
    super.initState();
  }

  Future<void> openGoogleMaps(String lat, String lng) async {
    final url = 'https://www.google.com/maps/@$lat,$lng,16z?entry=ttu';
    // final url = 'https://neshan.org/maps/@35.7486,51.335492,17z,0p';
    final uri = Uri.parse(url);
    await launchUrl(uri);
  }

  void fetchOrders() async {
    try {
      final orderService = OrderService();
      final fetchedOrders = await orderService.getOrders();
      setState(() {
        orders = fetchedOrders;
      });
      print('Your orders are $orders');

      List<OrderDetails?> orderDetailsList = []; // List to store order details

      for (Order order in orders) {
        final orderDetails =
            await OrderDetailsFetch().getOrderDetails(order.id);
        print('Order details for order ${order.id}: $orderDetails');
        orderDetailsList.add(orderDetails); // Add order details to the list
      }

      setState(() {
        orderDetails =
            orderDetailsList; // Update the orderDetails state variable
      });
    } catch (e) {
      print('Failed to fetch orders: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getDeviceInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _cellNumber = prefs.getString('cellNumber') ?? '';
      _firstName = prefs.getString('firstName') ?? '';
      _lastName = prefs.getString('lastName') ?? '';
    });
  }

  Future<void> _clearSharedPreferences() async {
    await clearSharedPreferences(
        context); // Call the method from admin_utils.dart
  }

  Future<void> _showConfirmationDialog() async {
    bool confirmed = await showConfirmationDialog(
        context); // Call the method from admin_utils.dart

    if (confirmed == true) {
      _clearSharedPreferences();
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
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF9BDCE0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_firstName $_lastName ${_cellNumber.withPersianNumbers()}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: Constants.textFont,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.logout_outlined),
                        onPressed: () {
                          _showConfirmationDialog();
                        },
                        tooltip: 'خروج از سامانه',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final orderDetail = orderDetails.length > index
                          ? orderDetails[index]
                          : null;
                      return Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 181, 243, 222),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.2), // Set the shadow color
                              spreadRadius: 2, // Set the spread radius
                              blurRadius: 3, // Set the blur radius
                              offset: Offset(0, 2), // Set the offset
                            ),
                          ],
                        ),
                        child: Theme(
                          data: ThemeData()
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Text(
                              'سفارش شماره ${order.id.toString().withPersianNumbers()}',
                              style: TextStyle(
                                fontFamily: Constants.textFont,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: [
                              ListTile(
                                title: Text(
                                  'نام سفارش: ${order.service}',
                                  style: TextStyle(
                                    fontFamily: Constants.textFont,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  // color: Colors.grey[200],
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      width: Constants.buttonWidth,
                                      height: Constants.buttonHeight,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: AlertDialog(
                                                    title: Text(
                                                      'جزئیات سفارش ${order.id.toString().withPersianNumbers()}',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            Constants.textFont,
                                                      ),
                                                    ),
                                                    content: ListTile(
                                                      title: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${orderDetail!.service["title"]}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  Constants
                                                                      .textFont,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: Constants
                                                                .textHeight,
                                                          ),
                                                          Text(
                                                            '${orderDetail.items[0]["title"]}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  Constants
                                                                      .textFont,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: Constants
                                                                .textHeight,
                                                          ),
                                                          Text(
                                                            '${orderDetail.items[0]["value"]}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  Constants
                                                                      .textFont,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: Constants
                                                                .textHeight,
                                                          ),
                                                          Text(
                                                            'تاریخ مراجعه: ${orderDetail.date}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  Constants
                                                                      .textFont,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: Constants
                                                                .textHeight,
                                                          ),
                                                          Text(
                                                            'زمان مراجعه: ${orderDetail.time}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  Constants
                                                                      .textFont,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: Constants
                                                                .textHeight,
                                                          ),
                                                          Text(
                                                            'آدرس: منطقه ${orderDetail.address["municipality_zone"]} ${orderDetail.address["text"]}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  Constants
                                                                      .textFont,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: Constants
                                                                .textHeight,
                                                          ),
                                                          Text(
                                                            'نام مشتری: ${orderDetail.user["name"]}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  Constants
                                                                      .textFont,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: Constants
                                                                .textHeight,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              String
                                                                  phoneNumber =
                                                                  orderDetail
                                                                          .user[
                                                                      "phone_number"];
                                                              Uri phoneUri =
                                                                  Uri.parse(
                                                                      'tel:$phoneNumber');
                                                              launchUrl(
                                                                  phoneUri);
                                                            },
                                                            child: Text.rich(
                                                              TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'شماره تلفن: ',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          Constants
                                                                              .textFont,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: orderDetail
                                                                        .user[
                                                                            "phone_number"]
                                                                        .toString()
                                                                        .withPersianNumbers(),
                                                                    style:
                                                                        TextStyle(
                                                                      decoration:
                                                                          TextDecoration
                                                                              .underline,
                                                                      decorationColor:
                                                                          Colors
                                                                              .blue,
                                                                      fontFamily:
                                                                          Constants
                                                                              .textFont,
                                                                      color: Colors
                                                                          .blue, // Set the desired color for the phone number
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: Constants
                                                                .textHeight,
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              openGoogleMaps(
                                                                  orderDetail
                                                                          .address[
                                                                      "latitude"],
                                                                  orderDetail
                                                                          .address[
                                                                      "longitude"]);
                                                              print(
                                                                  '${orderDetail.address["latitude"]} and ${orderDetail.address["longitude"]}');
                                                            },
                                                            child: Text(
                                                                'مشاهده لوکیشن روی نقشه'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            'خروج',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  Constants
                                                                      .textFont,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        child: Text('جزئیات سفارش'),
                                        style: Constants.getElevatedButtonStyle(
                                            ButtonType.details),
                                      ),
                                    ),
                                    OrderStateButtons(
                                        orderStatus: orderDetail!.orderStatus),
                                  ],
                                ),
                              ),
                              // Add more details as needed
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  fetchOrders();
                },
                child: Text('refresh'),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  final isPermissionsGranted =
                      await LocationService.isPermissionsGranted;
                  if (!isPermissionsGranted) return;
                  if (await LocationService.isServiceRunning) {
                    await LocationService.stop();
                    setState(() {
                      text = 'Start Service';
                    });
                  } else {
                    await LocationService.start();
                    setState(() {
                      text = 'Stop Service';
                    });
                  }
                },
                // child: Text('Start location'),
                child: Text(text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
