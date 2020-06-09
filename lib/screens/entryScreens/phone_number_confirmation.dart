import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:basket/Animation/FadeAnimation.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/customers.dart';
import 'package:basket/constants/images.dart';
import 'package:basket/screens/entryScreens/auth.dart';
import 'package:basket/screens/entryScreens/widgets/registration_widgets/card_widget.dart';
import 'package:basket/screens/entryScreens/widgets/registration_widgets/logo_widget.dart';
import 'package:basket/screens/home_page/home_page.dart';
import 'package:basket/screens/home_page/store.dart';
import 'package:basket/utils/size_config.dart';
import 'package:firebase_database/firebase_database.dart';


class PhoneNumberConfirmation extends StatefulWidget {

  String newCustomerID;
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  String password;

  PhoneNumberConfirmation({this.auth,this.newCustomerID,this.onSignedIn,this.password});

  @override
  _MyAppPageState createState() => _MyAppPageState();
}

class _MyAppPageState extends State<PhoneNumberConfirmation> {

  ////- send new customer id from SingUp Screen to search about customer
  ////- and get data for customer to update it by Phone Number
  ////- in initState get about customer from id (if confirmation Phone done )
  ///- before move to HomePage I update customer data by Phone Number

  customers newCustomer1;
  FirebaseDatabase _database = FirebaseDatabase.instance;


  @override
  void initState() {
    super.initState ();
    FirebaseDatabase.instance.reference().child("customers").
    child(widget.newCustomerID).once().then((DataSnapshot snapshot){
      newCustomer1 = customers.fromSnapshot(snapshot);
    }).then((d){
      if(mounted)
        setState(() {

        });
    });
    print("\n\n"+widget.newCustomerID);

  }
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;




  Future<void> verifyPhone() async {

    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo,
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent: smsOTPSent,
          // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('\n\n ${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
      print("\n\n\n"+e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text(translations.text("PhoneNumberConfirmationPage.SmsCode")),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text(translations.text("PhoneNumberConfirmationPage.Done")),
                onPressed: () {
                  _auth.currentUser().then((user) {
                    if (user == null) {
                      Navigator.of(context).pop();
                    } else {
                      signIn();
                      Navigator.of(context).pop();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      ////- from move to another screen
      //// update new customer informations mu adding Phone number
      await _database.reference ( ).child ( "customers" )
          .child ( newCustomer1.customerID )
          .set ( {
        "email":newCustomer1.email,
        "gender":"male",
        "isBlocked":false ,
        "name":newCustomer1.name,
        "latitude":1.1,
        "longitude":1.1,
        "phone":phoneNo

      });
      FirebaseUser user1 = (await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: newCustomer1.email, password: widget.password)).user;

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage( screen:Store(),auth: widget.auth,
        onSignedOut: widget.onSignedIn,
      )));
      widget.onSignedIn;
    } catch (e) {
      handleError(e);
      print("\n\n\n"+e);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) =>
          PhoneNumberConfirmation(auth:this.widget.auth,
            newCustomerID:widget.newCustomerID,onSignedIn: widget.onSignedIn,)));
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  Widget cardWidget = registrationCardWidget();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(
        builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return new Scaffold(
              body: SingleChildScrollView(
                child: new SafeArea(
                    child: new Stack(
                      children: <Widget>[
                        registrationLogo(),
                        FadeAnimation(1.8,Container(
                            margin: EdgeInsets.only(
                                left: 9.73 * SizeConfig.widthMultiplier,
                                right: 9.73 * SizeConfig.widthMultiplier,
                                top: 20.5 * SizeConfig.heightMultiplier,
                                bottom: 6.83 * SizeConfig.heightMultiplier),
                            alignment: Alignment.center,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 10.0,
                              child: Container(
                                height: 72.4 * SizeConfig.heightMultiplier,
                                width: 85.15 * SizeConfig.widthMultiplier,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    FadeAnimation(2.0,Align(
                                      alignment: Alignment.topCenter,
                                      child: new Container(
                                        margin: EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          translations.text("PhoneNumberConfirmationPage.PhoneAuthenticationText"),
                                          style: TextStyle(
                                              fontSize: 5.83 * SizeConfig.widthMultiplier,
                                              color: Colors.black87,
                                              fontStyle: FontStyle.normal),
                                        ),
                                      ),
                                    ),),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        width: 72.99 * SizeConfig.widthMultiplier,
                                        height: 41 * SizeConfig.heightMultiplier,
                                        child: Image.asset(Images.Sign_up),
                                      ),
                                    ),
                                    FadeAnimation(2.2,Container(
                                        margin: EdgeInsets.only(
                                            right: 3.64 * SizeConfig.widthMultiplier,
                                            left: 3.64 * SizeConfig.widthMultiplier),
                                        height: 5.47 * SizeConfig.heightMultiplier,
                                        width: 55.96 * SizeConfig.widthMultiplier,
                                        decoration: BoxDecoration(

                                            color: Color(0xffd7f7ea),
                                            borderRadius: new BorderRadius.all(Radius.circular(5.0))),

                                            //Card(child: Text("( +2 )"),),
                                            child:new TextField(
                                              onChanged: (value) {
                                                this.phoneNo = "+2"+value;

                                              },
                                              textAlign: TextAlign.left,
                                              style: TextStyle(fontSize: 3.64 * SizeConfig.widthMultiplier),
                                              decoration: new InputDecoration(
                                                alignLabelWithHint: true,
                                                border: InputBorder.none,
                                                fillColor: Color(0xffd7f7ea),
                                                labelText: "Phone Number Eg. +20",
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(10.0)),
                                                  borderSide: BorderSide(color: Colors.green),
                                                ),
                                                hintStyle: TextStyle(fontSize: 3.4 * SizeConfig.widthMultiplier),
                                                prefixIcon: Image.asset(Images.phoneIcon),
                                                prefix: Text("( +2 )  ",style:
                                                TextStyle(fontSize: 3.64  * SizeConfig.widthMultiplier,fontWeight: FontWeight.bold))
                                              ),
                                            ),
                                         ),),
                                    (errorMessage != '' ? Text( errorMessage, style: TextStyle(color: Colors.red), )
                                        : Container()),
                                    FadeAnimation(2.3,Container(
                                      margin: EdgeInsets.only(top: 2.73 * SizeConfig.heightMultiplier),
                                      child: new FlatButton(
                                        onPressed: () {
                                          verifyPhone();
                                        },
                                        padding: EdgeInsets.all(7.0),
                                        shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(5.0)),
                                        color: Color(0XFF21d493),
                                        child: new Text(
                                          translations.text("PhoneNumberConfirmationPage.registrationButton"),
                                          style: TextStyle(
                                            fontSize: 2.1 * SizeConfig.textMultiplier, color: Colors.white,),
                                        ),
                                      ),
                                    ),),
                                    FadeAnimation(2.4,Container(
                                      margin: EdgeInsets.only(
                                          top: 1.8 * SizeConfig.heightMultiplier,
                                          bottom: 1.5 * SizeConfig.heightMultiplier),
                                      child: Text(
                                        translations.text("PhoneNumberConfirmationPage.cardWidget.phoneNumber"),
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 2.0 * SizeConfig.textMultiplier),
                                      ),
                                    ),)
                                  ],
                                ),
                              ),
                            ))),
                      ],
                    )),
              ));
        },
      );
    });
  }
}