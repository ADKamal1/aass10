import 'package:flutter/material.dart';

class registrationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15.0, left: 15.0),
      child: new FlatButton(
        padding: EdgeInsets.all(7.0),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0)),
        color: Color(0XFF21d493),
        child: new Text(
          "Add To Cart",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        onPressed: () {},
      ),
    );
  }
}
//TODO has no meaning now must deleted...
