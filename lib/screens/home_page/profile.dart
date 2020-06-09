import 'package:flutter/material.dart';
import 'package:basket/_model/customers.dart';
import 'package:basket/screens/entryScreens/auth.dart';
import 'package:basket/utils/size_config.dart';
import 'widgets/profile_body.dart';
import 'widgets/profile_header.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Profile extends StatefulWidget {
  final Function() notifyParent;

  final BaseAuth auth;
  Profile({this.notifyParent,this.auth,});

  @override
  _Profile createState() => _Profile();
}


class _Profile extends State<Profile> {
  customers authenticatedCustomer;
  bool isAuthenticated = false;
  @override
  void initState() {
    super.initState();



    FirebaseAuth.instance.currentUser().then((user) async{
      if(user != null){
        String userId = user.uid;
        isAuthenticated = true;
        await FirebaseDatabase.instance.reference().child("customers").
           child(userId).once().then((DataSnapshot snapshot){
          authenticatedCustomer = customers.fromSnapshot(snapshot);
        });
        // usser is authenticated..
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
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return ListView(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(
                    bottom: SizeConfig.getResponsiveHeight(2.0)),
                height: SizeConfig.getResponsiveHeight(150.0),
                decoration: BoxDecoration(
                  color: Color(0XFF21d493),
                  borderRadius: BorderRadius.only(
                      bottomRight:
                          Radius.circular(SizeConfig.getResponsiveHeight(20)),
                      bottomLeft: Radius.circular(
                          SizeConfig.getResponsiveHeight(20.0))),
                ),
                child: Center(child: ProfileHeader(
                    authenticatedCustomer:authenticatedCustomer , isAuthenticated:isAuthenticated))),
            ProfileBody(auth: widget.auth),
          ],
        );
      });
    });
  }
}
