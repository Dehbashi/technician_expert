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
      case 3:
        buttons = Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              width: Constants.buttonWidth,
              height: Constants.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  StateService(status: 4);
                },
                child: Text('قبول سفارش'),
                style: Constants.getElevatedButtonStyle(ButtonType.accept),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: Constants.buttonWidth,
              height: Constants.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  StateService(status: 1);
                },
                child: Text('رد سفارش'),
                style: Constants.getElevatedButtonStyle(ButtonType.cancel),
              ),
            ),
          ],
        );

      case 4:
        buttons = Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              width: Constants.buttonWidth,
              height: Constants.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  StateService(status: 5);
                },
                child: Text('عدم حضور مشتری'),
                style: Constants.getElevatedButtonStyle(ButtonType.accept),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: Constants.buttonWidth,
              height: Constants.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  StateService(status: 5);
                },
                child: Text('حضور مشتری'),
                style: Constants.getElevatedButtonStyle(ButtonType.cancel),
              ),
            ),
          ],
        );

      case 6:
        buttons = Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              width: Constants.buttonWidth,
              height: Constants.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  StateService(status: 7);
                },
                child: Text('نیاز به خرید اقلام'),
                style: Constants.getElevatedButtonStyle(ButtonType.accept),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: Constants.buttonWidth,
              height: Constants.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  StateService(status: 8);
                },
                child: Text('اتمام کار'),
                style: Constants.getElevatedButtonStyle(ButtonType.cancel),
              ),
            ),
          ],
        );

      case 7:
        buttons = Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              width: Constants.buttonWidth,
              height: Constants.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  StateService(status: 8);
                },
                child: Text('اتمام کار'),
                style: Constants.getElevatedButtonStyle(ButtonType.accept),
              ),
            ),
          ],
        );

      default:
        buttons = Container();
    }

    return buttons;
  }
}
