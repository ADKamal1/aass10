import 'package:flutter/material.dart';

class AppbarIcon extends StatelessWidget {
  String iconPath;
  int number;
  double top = 0, bottom = 0, right = 0, left = 0;
  Color iconColor = Colors.white, notificationColor = Colors.white;

  AppbarIcon(
      {@required this.iconPath,
      this.iconColor,
      this.number,
      this.notificationColor,
      this.top,
      this.bottom,
      this.left,
      this.right});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new IconButton(
          icon: new Image.asset(
            iconPath,
            color: Colors.white,
          ),
        ),
//              onPressed: null),
        Positioned(
          top: top,
          right: right,
          bottom: bottom,
          left: left,
          child: Container(
            decoration: BoxDecoration(
              color: notificationColor,
              borderRadius: BorderRadius.circular(6),
            ),
            height: 15,
            width: 15,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "${number.toString()}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                height: 7,
                width: 7,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
