import 'package:flutter/material.dart';
import '../constans.dart';
import '../services/state_service.dart';

class OrderStateButtons extends StatefulWidget {
  // const OrderState({super.key});
  final int orderStatus;

  OrderStateButtons({required this.orderStatus});

  @override
  State<OrderStateButtons> createState() => _OrderStateButtonsState();
}

class _OrderStateButtonsState extends State<OrderStateButtons> {
  @override
  Widget build(BuildContext context) {
    Widget buttons;

    switch (widget.orderStatus) {
      case 1:
        buttons = Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              width: Constants.buttonWidth,
              height: Constants.buttonHeight,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('قبول سفارش'),
                style: Constants.getElevatedButtonStyle(ButtonType.accept),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: Constants.buttonWidth,
              height: Constants.buttonHeight,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('رد سفارش'),
                style: Constants.getElevatedButtonStyle(ButtonType.cancel),
              ),
            ),
          ],
        );

      case 2:
        buttons = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                width: Constants.buttonWidth,
                height: Constants.buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    StateService(status: widget.orderStatus);
                    print(widget.orderStatus);
                  },
                  child: Text('حضور'),
                  style: Constants.getElevatedButtonStyle(ButtonType.accept),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                width: Constants.buttonWidth,
                height: Constants.buttonHeight,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('عدم حضور'),
                  style: Constants.getElevatedButtonStyle(ButtonType.cancel),
                ),
              ),
            ],
          ),
        );
      default:
        buttons = Container();
    }

    return buttons;
  }
}
