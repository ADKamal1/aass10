import 'dart:io';
import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/customers.dart';
import 'package:basket/screens/entryScreens/widgets/UtilityImage.dart';
import 'package:basket/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';


class ProfileHeader extends StatefulWidget {
  customers authenticatedCustomer;
  bool isAuthenticated = false;
  ProfileHeader({this.isAuthenticated , this.authenticatedCustomer});
  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  bool isAuthenticated = false;
  customers authenticatedCustomer;

  ///- for Profile Image From SharedPerference
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
  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }
  Widget imageFromGallery(){
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          //print(snapshot.data.path);
          Utility.saveImageToPreferences(
              Utility.base64String(snapshot.data.readAsBytesSync()));
          return Image.file(
            snapshot.data,
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return  Container();
        }
      },
    );}


  bool authenticated = false;
  UserAuthenticated()async{
    if(await FirebaseAuth.instance.currentUser() != null){
       authenticated = true;
    }else{
      authenticated = false;
    }
  }

  @override
  void initState() {

    loadImageFromPreferences();
    UserAuthenticated();

    FirebaseAuth.instance.currentUser().then((user) async{
      if(user != null) {
        String userId = user.uid;
        isAuthenticated = true;
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
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: SizeConfig.getResponsiveHeight(10)),
            child:(isAuthenticated == true)?
            FittedBox(
              fit: BoxFit.cover,
              child: GestureDetector(
                onTap: () {
                  pickImageFromGallery(ImageSource.gallery);
                  setState(() {
                    imageFromSharedPreferences = null;
                  });
                },
                child: Container(
                    child: (imageFromSharedPreferences != null)?Container(
                        height: SizeConfig.getResponsiveHeight(93.0),
                        width: SizeConfig.getResponsiveWidth(112.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(180.0),
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child:imageFromSharedPreferences,
                          ),
                        )): Container(
                        child:GestureDetector(
                            onTap: () {
                              pickImageFromGallery(ImageSource.gallery);
                              setState(() {
                                imageFromSharedPreferences = null;
                              });
                            },
                            child:Container(
                                height: SizeConfig.getResponsiveHeight(93.0),
                                width: SizeConfig.getResponsiveWidth(112.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(180.0),
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child:imageFromGallery(),
                                  ),
                                )))
                    )),
              ),
            ):Container(
                height: SizeConfig.getResponsiveHeight(93.0),
                width: SizeConfig.getResponsiveWidth(112.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(180.0),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child:CircleAvatar(
                      backgroundImage: AssetImage("assets/images/profile_side_menu.png"),
                      //radius: SizeConfig.getResponsiveHeight(40),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                )),
        ),
        (widget.authenticatedCustomer == null)?Container(): Container(
          margin:EdgeInsets.only(top: SizeConfig.getResponsiveHeight(10),bottom: SizeConfig.getResponsiveHeight(7)),
          child:Text(
          (widget.isAuthenticated == true && widget.authenticatedCustomer.name != null)?
          widget.authenticatedCustomer.name: "",

          style: TextStyle(fontSize: 15 , color: Colors.black87),
        ),),

        (widget.authenticatedCustomer == null)?Container():  Container(
          margin:EdgeInsets.only(bottom: SizeConfig.getResponsiveHeight(3)),
          child: Text(
            (widget.isAuthenticated == true && widget.authenticatedCustomer.phone != null)?
            widget.authenticatedCustomer.phone: "",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),




      ],
    );
  }
}

