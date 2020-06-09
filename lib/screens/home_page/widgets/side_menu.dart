import 'dart:io';
import 'package:flutter/material.dart';
import 'package:basket/Localization/settings.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/customers.dart';
import 'package:basket/screens/company_related_screens/about_company.dart';
import 'package:basket/screens/company_related_screens/contact_us.dart';
import 'package:basket/screens/company_related_screens/politics_and_safety.dart';
import 'package:basket/screens/entryScreens/auth.dart';
import 'package:basket/screens/entryScreens/welcome.dart';
import 'package:basket/screens/entryScreens/widgets/UtilityImage.dart';
import 'package:basket/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SideMenu extends StatefulWidget {
  final BaseAuth auth;
  BuildContext parentContext;

  SideMenu({this.auth, this.parentContext});

  @override
  _SideMenu createState() => _SideMenu();
}


class _SideMenu extends State<SideMenu> {

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

  customers authenticatedCustomer;
  bool isAuthenticated = false;
  getCurrentUser(){
    FirebaseAuth.instance.currentUser().then((user) async{
      if(user != null) {
        String userId = user.uid;
        isAuthenticated = true;
        print("\n\n\n"+userId);
        await FirebaseDatabase.instance.reference().child("customers").
        child(userId).once().then((DataSnapshot snapshot){
          authenticatedCustomer = customers.fromSnapshot(snapshot);
        });
      }else{
        isAuthenticated = false;
      }
    }).then((d){
      if(mounted)
        setState(() {

        });
    });
  }

  @override
  void initState() {
    super.initState();
    loadImageFromPreferences();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            height: SizeConfig.getResponsiveHeight(250.0),
            width: MediaQuery.of(context).size.width,
            child: DrawerHeader(
              child: Container(
                child: Column(
                  children: <Widget>[
                    FittedBox(
                      fit: BoxFit.cover,
                      child: Container(
                        margin: EdgeInsets.only(top: SizeConfig.getResponsiveHeight(13)),
                        child: ( imageFromSharedPreferences != null)?Container(
                          height: SizeConfig.getResponsiveHeight(93.0),
                          width: SizeConfig.getResponsiveWidth(112.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(180.0),
                            child:FittedBox(
                                fit: BoxFit.cover,
                                child:imageFromSharedPreferences
                            ),),
                        ):  Container(
                          margin: EdgeInsets.only(top: SizeConfig.getResponsiveHeight(13)),
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/images/profile_side_menu.png"),
                            radius: SizeConfig.getResponsiveHeight(40),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),

                    ),

                    (authenticatedCustomer == null)?Container(): Container(
                        margin: EdgeInsets.only(top: 15),
                        child:Text(
                      (isAuthenticated == true && authenticatedCustomer.name != null)?
                      authenticatedCustomer.name: "",

                      style: TextStyle( fontSize: 15),
                    )),

                    (authenticatedCustomer == null)?Container():  Text(
                      (isAuthenticated == true && authenticatedCustomer.phone != null)?authenticatedCustomer.phone: "",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )


                  ],
                ),
              ),
            ),
          ),

          ListTile(
              onTap: () {
                Navigator.of(context).pop();
                return Navigator.push(
                    widget.parentContext,
                    MaterialPageRoute(
                        builder: (parentContext) => new politicsAndSafety()));
              },
              leading: Image.asset('assets/images/side_menu_image/policy.png'),
              title: Text(
                translations.text("SideMenuPage.sidePolitics"),
                style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: MediaQuery.of(context).size.height >= 736 ? 20 : 14,
                    fontWeight: FontWeight.bold
                ),
              )),
          ListTile(
              onTap: () {
                Navigator.of(context).pop();
                return Navigator.push(
                    widget.parentContext,
                    MaterialPageRoute(
                        builder: (parentContext) => new contactUs()));
              },
              leading: Image.asset('assets/images/side_menu_image/contact.png'),
              title: Text(
                translations.text("SideMenuPage.sideContact"),
                style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: MediaQuery.of(context).size.height >= 736 ? 20 : 14,
                    fontWeight: FontWeight.bold
                ),
              )),
          ListTile(
              onTap: () {
                Navigator.of(context).pop();
                return Navigator.push(
                    widget.parentContext,
                    MaterialPageRoute(
                        builder: (parentContext) => new aboutCompany()));
              },
              leading: Image.asset('assets/images/side_menu_image/about.png'),
              title: Text(
                translations.text("SideMenuPage.sideAboutCompany"),
                style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: MediaQuery.of(context).size.height >= 736 ? 20 : 14,
                    fontWeight: FontWeight.bold
                ),
              )),

          ListTile(
              onTap: () {
                Navigator.of(context).pop();
                return Navigator.push(
                    widget.parentContext,
                    MaterialPageRoute(
                        builder: (parentContext) => new SettingsPage()));
              },
              leading:
                  Image.asset('assets/images/side_menu_image/language.png'),
              title: Text(
                translations.text("SideMenuPage.changeLanguage"),
                style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: MediaQuery.of(context).size.height >= 736 ? 20 : 14,
                    fontWeight: FontWeight.bold
                ),
              )),
          isAuthenticated==false?
              ListTile(
                  onTap: () async {
                    await widget.auth.signOut();
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (context) => new Welcome(
                              auth: widget.auth,
                            )));
                  },
                  leading:
                      Image.asset('assets/images/side_menu_image/login.png'),
                  title: Text(
                    translations.text("SideMenuPage.LogIn"),
                    style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      fontSize: MediaQuery.of(context).size.height >= 736 ? 20 : 14,
                        fontWeight: FontWeight.bold
                    ),
                  ))
              : ListTile(
                  onTap: () async {
                    await widget.auth.signOut();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new Welcome(
                              auth: widget.auth,
                            )));
                  },
                  leading:
                      Image.asset('assets/images/side_menu_image/login.png'),
                  title: Text(
                    translations.text("SideMenuPage.LogOut"),
                    style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      fontSize: MediaQuery.of(context).size.height >= 736 ? 20 : 14,
                        fontWeight: FontWeight.bold
                    ),
                  ))
        ],
      ),
    );
  }
}
