import 'package:flutter/material.dart';
import 'package:technician/screen/widget/confirmation_dialog.dart';
import '../constans.dart';
import '../services/state_service.dart';

class OrderStateButtons extends StatefulWidget {
  // const OrderState({super.key});
  int orderStatus;
  final int id;

  OrderStateButtons({required this.orderStatus, required this.id});

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
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmationDialog(
                          title: 'تأیید',
                          message: 'آیا از پذیرفتن سفارش مطمئن هستید؟',
                          onConfirm: () {
                            StateService(status: 4, id: widget.id).getStatus();
                            setState(() {
                              widget.orderStatus = 4;
                            });
                          },
                        );
                      });
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
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmationDialog(
                          title: 'تأیید',
                          message: 'آیا از رد سفارش مطمئن هستید؟',
                          onConfirm: () {
                            StateService(status: 1, id: widget.id).getStatus();
                          },
                        );
                      });
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
                  StateService(status: 6, id: widget.id).getStatus();
                  setState(() {
                    widget.orderStatus = 6;
                  });
                },
                child: Text('حضور مشتری'),
                style: Constants.getElevatedButtonStyle(ButtonType.accept),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: Constants.buttonWidth,
              height: Constants.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  StateService(status: 5, id: widget.id).getStatus();
                  print('The id is ${widget.id} and the status is 5');
                },
                child: Text('عدم حضور مشتری'),
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
                  StateService(status: 7, id: widget.id).getStatus();
                  setState(() {
                    widget.orderStatus = 7;
                  });
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
                  StateService(status: 8, id: widget.id).getStatus();
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
                  StateService(status: 8, id: widget.id).getStatus();
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
