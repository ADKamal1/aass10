
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:basket/_model/customers.dart';
import 'package:basket/utils/size_config.dart';
import 'package:intl/intl.dart';

import 'Localization/translation/global_translation.dart';
import '_model/Product_Offer.dart';
import '_model/customerOrderDetails.dart';
import 'screens/entryScreens/widgets/UtilityImage.dart';
import 'screens/purchase/widgets/OrderQrCode.dart';

class Ordercard extends StatefulWidget {

  customers authenticatedCustomer;
  CustomerOrderDetails customerDetails;
  Ordercard({this.customerDetails ,this.authenticatedCustomer});

  @override
  _OrdercardState createState() => _OrdercardState();
}

class _OrdercardState extends State<Ordercard> {

  ///- for Customer Image
  Future<File> imageFile;
  Image imageFromSharedPreferences;
  loadImageFromPreferences() {
    Utility.getImageFromPreferences().then((img) {
      if (null == img) {
        return(Container(child:Center(child: Text("no image"))));
      }
      setState(() {
        imageFromSharedPreferences = Utility.imageFromBase64String(img);
      });
    });
  }

  ///- for time
    var now = new DateTime.now();
    //var formatter = new DateFormat.yMMMMd('en_US');
    var formatter = new DateFormat.yMd();


    @override
  void initState() {
    super.initState();
    loadImageFromPreferences();

//    String startTime = DateFormat('kk:mm').format(widget.customerDetails.customerOrder.deliveryDateForm);
//    String finishTime = DateFormat('kk:mm').format(widget.customerDetails.customerOrder.deliveryDateTo);
//    String orderDate = DateFormat('yyyy-MM-dd').format(widget.customerDetails.customerOrder.deliveryDate);
//
    }


  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
      if (widget.customerDetails.customerOrder.state != 4){
        Navigator.push ( context, new MaterialPageRoute( builder: (context) =>
            OrderQrCode(qrText: widget.customerDetails.customerOrder.orderID+widget.authenticatedCustomer.customerID,)));
    }else{
        /////- alert (that order is complated )
        _displayDialog(context);
      }
    ;},

        child:Container(
        margin: EdgeInsets.all(SizeConfig.getResponsiveWidth(5)),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          color: Colors.white,
          elevation: 3,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: SizeConfig.getResponsiveHeight(10.0),
                      bottom: SizeConfig.getResponsiveHeight(5.0),
                      left: SizeConfig.getResponsiveWidth(20.0),
                      right: SizeConfig.getResponsiveWidth(20.0),
                    ),
                    child: Text(
                      widget.authenticatedCustomer.name==null?"Client":widget.authenticatedCustomer.name,
                      style: new TextStyle(
                          color: Color(0XFF21d493),
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.getResponsiveWidth(20.0)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.getResponsiveHeight(15.0),
                        left: SizeConfig.getResponsiveWidth(15.0),
                        right: SizeConfig.getResponsiveWidth(15.0)),
                    decoration:(widget.customerDetails.customerOrder.state == 4)? BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius:
                        new BorderRadius.all(Radius.circular(3.0))):
                    BoxDecoration(
                        color: Colors.red[100],
                        borderRadius:
                            new BorderRadius.all(Radius.circular(3.0))),
                    width: SizeConfig.getResponsiveWidth(90.0),
                    height: SizeConfig.getResponsiveHeight(20.0),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: (widget.customerDetails.customerOrder.state ==4)
                              ? Text(
                            (translations.currentLanguage == 'en')?"completed":"منتهى",
                                  style: new TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          SizeConfig.getResponsiveWidth(25.0)),
                                )
                              :
                          widget.customerDetails.customerOrder.state ==0?
                        Text(
                            (translations.currentLanguage == 'ar')?"قيد الانتـظـار":"pending",
                        style: new TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize:
                            SizeConfig.getResponsiveWidth(
                                25.0)),
                      ):
                          widget.customerDetails.customerOrder.state ==1?
                          Text(
                            (translations.currentLanguage == 'ar')?"تم الاسـتـلام":"deliverd",
                            style: new TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                SizeConfig.getResponsiveWidth(
                                    25.0)),
                          ):
                          widget.customerDetails.customerOrder.state ==2?
                          Text(
                            (translations.currentLanguage == 'ar')?"تم الشـحـن":"charged",
                            style: new TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                SizeConfig.getResponsiveWidth(
                                    25.0)),
                          ):
                          Text(
                            (translations.currentLanguage == 'ar')?"تم الشـحـن":"charged",
                            style: new TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                SizeConfig.getResponsiveWidth(
                                    25.0)),
                          )
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                       imageFromSharedPreferences != null?Container(
                           height: SizeConfig.getResponsiveHeight(73.0),
                           width: SizeConfig.getResponsiveWidth(92.0),
                           margin: EdgeInsets.only( left: SizeConfig.getResponsiveWidth(10.0),
                             right: SizeConfig.getResponsiveWidth(10.0), ),
                           child: ClipRRect(
                             borderRadius: BorderRadius.circular(160.0),
                             child: FittedBox(
                               fit: BoxFit.cover,
                               child:imageFromSharedPreferences,
                             ),
                           )):  Container(
                        margin: EdgeInsets.only(top: SizeConfig.getResponsiveHeight(13)),
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/images/profile_side_menu.png"),
                          radius: SizeConfig.getResponsiveHeight(40),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                  Column(
                    children: <Widget>[
                      widget.customerDetails.customerOrder.state ==0?Container():
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Image.asset('assets/images/icons/order_done.png',width: 35,height: 35,),
                            SizedBox(width: 15,),
                            Text(translations.currentLanguage=='en'?"Delivered ":
                            "يـــســـلـــمــ ",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.getResponsiveWidth(15),
                              ),
                            ),
                            SizedBox(width: 20,)

                          ],)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Image.asset('assets/images/icons/order_history.png',width: 25,height: 25,),
                            widget.customerDetails.customerOrder.state ==0?SizedBox(width: 16,):SizedBox(width: 8,),

                            Text(
                              DateFormat('yyyy-MM-dd').format(widget.customerDetails.customerOrder.deliveryDate),
                              style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.getResponsiveWidth(15),
                              ),
                            ),
                            SizedBox(width: 15,)

                          ],)
                        ],
                      ),
                    ],
                  ),



                ],
              ),
             SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: <Widget>[
                    Image.asset('assets/images/icons/order_price.png',width: 35,height: 35,),
                      (translations.currentLanguage == 'ar')?
                      Text(
                        " ${widget.customerDetails.customerOrder.totalPrice.toString()} ر.س " ,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.getResponsiveWidth(15),
                        ),) :
                      Text(
                        " ${widget.customerDetails.customerOrder.totalPrice.toString()} SAR" ,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.getResponsiveWidth(15),
                        ),
                    ),
                    SizedBox(width: 15,)

                  ],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Image.asset('assets/images/icons/order_time.png',width: 30,height: 30,),
                        widget.customerDetails.customerOrder.state ==0?SizedBox(width: 8,):SizedBox(width: 5,),
                        Text(
                          DateFormat('kk:mm').format(widget.customerDetails.customerOrder.deliveryDateForm)+" : "
                          +DateFormat('kk:mm').format(widget.customerDetails.customerOrder.deliveryDateTo),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.getResponsiveWidth(15),
                          ),
                        ),
                        SizedBox(width: 15,)

                      ],)
                    ],
                  ),
                ],
              )
            ],
          ),
        )));
  }
}

_displayDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(translations.currentLanguage=='en'?'Client\'s Order':"طــلـــــب اـلـــعـــمـــيـــل"),
          content: Container(
            width: double.maxFinite,
            child:Text(translations.currentLanguage=='en'?"That Order Finished":"هــذا الــطـــلـــب مــنــتــهــــي",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
            )
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(translations.currentLanguage=='en'?'CLOSE':"إغـــلــاــق"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}


