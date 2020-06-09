import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/screens/entryScreens/auth.dart';
import 'package:basket/screens/entryScreens/sign_in.dart';
import 'package:basket/utils/size_config.dart';


class ResetPassword extends StatefulWidget{
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  ResetPassword({this.auth,this.onSignedIn});
  @override
  State<StatefulWidget> createState() => _ResetPassword();
}


class _ResetPassword extends State<ResetPassword>{
   final EmailController = TextEditingController();

  BaseAuth auth;
  final formKey = new GlobalKey<FormState>();
  String email;


  // to show message in error statu
  void _showDialog(String message) {
    print(message);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(translations.text("ResetPasswordPage.title")),
        content: Text(translations.text("ResetPasswordPage.ResetMessageText")+ "$message"),
        actions: <Widget>[
          FlatButton(
            child: Text(translations.text("ResetPasswordPage.ResetMessageDialogButton")),
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.auth.sendPasswordRestEmail(message);
              Navigator.of(context).push( new MaterialPageRoute( builder: (context) => new SignIn()));
            }
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;

      return LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return Scaffold(
            backgroundColor: Colors.white,
            body: Form(
              key: formKey,
              child: ListView(
                children: <Widget>[
                  Card(
                      margin: EdgeInsets.all(0.0),
                      color: Color(0xff21d493),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0))),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(
                                    top: SizeConfig.getResponsiveHeight(20.0)),
                                child: Text(
                                  translations.text("ResetPasswordPage.ResetPasswordText"),
                                  style: TextStyle(
                                      fontSize:
                                      SizeConfig.getResponsiveHeight(25.0),
                                      color: Colors.white),
                                )),
                            Container(
                              width: SizeConfig.getResponsiveWidth(300.0),
                              height: SizeConfig.getResponsiveHeight(120.0),
                              child: Image.asset('assets/images/about_company.png'),
                            )
                          ],
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, right: 25, left: 25),
                    child:TextFormField(
                      controller: EmailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                      },
                      onSaved: (value) => email= value,
                      decoration: new InputDecoration(
                        labelText: translations.text("ResetPasswordPage.ResetPasswordEmail"),
                        prefixIcon: Icon(Icons.email,color: Colors.green,),
                        //labelText: AppLocalizations.of(context).categoryNameFruite,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(15.0)),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),

                    Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.getResponsiveHeight(20.0),
                            right: SizeConfig.getResponsiveWidth(50.0),
                            left: SizeConfig.getResponsiveWidth(50.0)),
                        child: RaisedButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          onPressed: () {
                            _showDialog(EmailController.text);
                          },
                          textColor: Colors.white,
                          color: Colors.white,
                          padding: EdgeInsets.all(0.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff21d493),
                                borderRadius:
                                new BorderRadius.all(Radius.circular(40.0))),

                            alignment: Alignment.center,
                            width: SizeConfig.getResponsiveWidth(90.0),

                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              translations.text("ResetPasswordPage.ResetMessageButton"),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.getResponsiveHeight(15.0),
                              ),
                            ),
                          ),
                        ),
                      ),



                 Container(
                      width: 200.0,
                      margin: EdgeInsets.only(
                          top: SizeConfig.getResponsiveHeight(10.0),
                          left: 35.0,
                          right: 35.0),
                      child: new FlatButton(
                        padding: EdgeInsets.all(7.0),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                        color: Colors.white,
                        child: new Text(
                          translations.text("ResetPasswordPage.ResetMessageReturnText"),
                          style: TextStyle(
                              fontSize: SizeConfig.getResponsiveHeight(12),
                              color: Color(0xff21d493)),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new SignIn()));
                        },
                      ),
                    ),

                ],
              ),
            ),
          );
        });
      });

  }
}


//
//Widget socialIconsRow() {
//  return Container(
//    margin: EdgeInsets.only(top: SizeConfig.getResponsiveHeight(0)),
//    child: Row(
//      mainAxisAlignment: MainAxisAlignment.center,
//      mainAxisSize: MainAxisSize.min,
//      children: <Widget>[
//        CircleAvatar(
//          radius: 15,
//          backgroundImage: AssetImage("assets/images/googlelogo.png"),
//        ),
//        SizedBox(
//          width: 20,
//        ),
//        CircleAvatar(
//          radius: 15,
//          backgroundImage: AssetImage("assets/images/fblogo.jpg"),
//        ),
//        SizedBox(
//          width: 20,
//        ),
//        CircleAvatar(
//          radius: 15,
//          backgroundImage: AssetImage("assets/images/twitterlogo.jpg"),
//        ),
//      ],
//    ),
//  );
//}
