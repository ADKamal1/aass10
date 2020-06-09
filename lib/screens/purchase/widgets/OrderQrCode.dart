import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';



class OrderQrCode extends StatelessWidget{
  String qrText;
  OrderQrCode({this.qrText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Process Confirmation"),
        centerTitle: true,
        backgroundColor: Color(0XFF21d493),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            QrImage(
              data: qrText,
              size: 250,
              gapless: true,
              errorCorrectionLevel: QrErrorCorrectLevel.Q,
              foregroundColor: Colors.green[300],
              backgroundColor: Colors.black,
            )

          ],
        ),
      ),
    );
  }

}