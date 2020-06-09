import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import './location.dart';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CustomerLocation.dart';

class theMapClass extends StatefulWidget {


  @override
  _theMapClassState createState() => _theMapClassState();
}



class _theMapClassState extends State<theMapClass> {
  double choosenLatitude;
  double choosenLongitude;

  CustomerLocation object = new CustomerLocation();


  static double deviceLongitude;
  static double deviceLatitude;
  double onMoveLatitude;
  double onMoveLongitude;
  double onTapLatitude;
  double onTapLongitude;
  Widget pinMark;
  static final double _zoom = 15.3;
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = Set();


  /// to get phone location
  void getLocation() async {
    Location location = Location();
    await location.getCurrentLocation();



    setState(() {
      location==null?Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ):
      deviceLongitude=location.longtude;
      deviceLatitude=location.latitude;

      object.customerLocationLatitude=choosenLatitude=deviceLatitude;
      object.customerLocationLongitude=choosenLongitude=deviceLongitude;

      //print('my phone location lat is ${deviceLatitude.toString()}');
      //print('my phone location long  is ${deviceLongitude.toString()}');

      //print('\n\nmy Choosen location lat Now is ${choosenLatitude.toString()}');
      //print('\nmy Choosen location long Now is ${choosenLongitude.toString()}');
    });
  }

  /// to open google maps in determined Location
  static Future<void> openGoogleMapApp({double latitude, double longitude}) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
      print('opnenig');
    } else {
      throw 'Could not open the map.';
    }}

  /// do any thing when camera moving
  whenMapCameraMoving(result){
    setState(() {
      onMoveLatitude = result.target.latitude;
      onMoveLongitude = result.target.longitude;
      //print('lat  on moving map  is ${onMoveLatitude.toString()}');
      //print('long  on moving map is ${onMoveLongitude.toString()}');
      object.customerLocationLatitude=choosenLatitude=onMoveLatitude;
      object.customerLocationLongitude=choosenLongitude=onMoveLongitude;

      //print('\n\nmy Choosen location lat Now is ${choosenLatitude.toString()}');
      //print('\nmy Choosen location long Now is ${choosenLongitude.toString()}');



    });
  }

  /// do any thing when camera Stop moving
  whenMapCameraStopMoving(result){
    setState(() {
      onMoveLatitude = result.target.latitude;
      onMoveLongitude = result.target.longitude;
      //print('lat  on moving map  is ${onMoveLatitude.toString()}');
      //print('long  on moving map is ${onMoveLongitude.toString()}');

    });
  }

  /// to make map camera move  to phone location
  Future<void> _goToMyLocation() async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(deviceLatitude, deviceLongitude), _zoom));
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId('phoneLocation'),
            position: LatLng(deviceLatitude, deviceLongitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              30.0,
            ),
            alpha: 0.0,
            infoWindow: InfoWindow(
              title: 'My location',
            )),
      );
    });
  }

  /// this function do map camera move  when tap on map
  Future<void> _goToTapLocation(LatLng latLng) async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
            target: latLng,
            zoom: 15.3
        )));
    object.customerLocationLatitude=deviceLatitude;
    object.customerLocationLongitude=deviceLongitude;

  }

  /// to convert img  to mack pin mark
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();


  }

  /// to move map camera to determined Location and put Marker
  Future<void> movingMapCameraAndPutMark({double latitude,double longitude}) async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/images/mar3.png', 90);
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('mark'),
          position: LatLng(latitude, longitude),
          alpha: 0.9,
          icon: BitmapDescriptor.fromBytes(markerIcon),   ////////////

        ),
      );
    });
  }

  _dismissDialog(BuildContext context) {
    Navigator.pop(context);
  }




  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(
                      Radius.circular(15.0))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 40,
                      backgroundImage: AssetImage("assets/images/true.png"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Text(translations.text("MapPage.DialogBody") ,
                      style: TextStyle(fontSize: 18.0),),          /////////localiz
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        color: Color.fromRGBO(33, 212, 147, 1),
                        onPressed: () {
                          _dismissDialog(context);
                        },
                        child: Container(
                            child: Text(translations.currentLanguage=='en'?'Okay':"حـسـنــــاً",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    color: Colors.white))),
                      )

                    ],
                  )




                ],
              ),





            );

          }
      );
    });

    //_showCupertinoDialog(theMapClass());
    /// to get phone location
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>Future.value(false),
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 5),
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              deviceLongitude==null||deviceLongitude==null?Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(),
                  )):GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition:  CameraPosition (
                  target: LatLng ( deviceLatitude, deviceLongitude, ),
                  zoom: _zoom,
                ),
                markers: _markers,
                padding: EdgeInsets.all(60.0),
                myLocationButtonEnabled: false,
                myLocationEnabled: true,

                onMapCreated: (GoogleMapController controller) async{
                  _controller.complete(controller);
                },

                onCameraMove: (result) async{
                  whenMapCameraMoving(result);
                },
                onCameraIdle:(){

                  ////- here my lat and log for app
                  // print('\n\nmy Choosen location lat Now is ${widget.choosenLatitude.toString()}');
                  //print('\nmy Choosen location long Now is ${widget.choosenLongitude.toString()}');



                  /// when map camera stop moving
                  // do any thing here
                  movingMapCameraAndPutMark(latitude: onTapLatitude,longitude: onTapLongitude);
                },
                onTap: (latLng) {
                  /// when tap location on map
                  _goToTapLocation(latLng);
                  onTapLatitude=latLng.latitude;
                  onTapLongitude=latLng.longitude;

//                debugPrint('\n\n\n\non tap latitude is =${onTapLatitude.toString()} '
//                    ' on tap longitude is = ${onTapLongitude.toString()}, \n\n');
                },
              ),

              /// my location button
              Positioned(
                bottom: 0.0,
                height: 50.0,
                width: 50.0,
                right: 22.0,
                child: FloatingActionButton.extended(
                  backgroundColor: Color(0XFF21d493),
                  onPressed: () {
                    setState(() {
                      _goToMyLocation();
                    });
                  },
                  label: Icon(
                    Icons.my_location,
                    size: 25.0,
                  ),
                  elevation: 0.5,
                ),
              ),

              /// to back for my app and upload Lat and Long
              Positioned(
                top: 10.0,
                right: 40,
                left: 40,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)
                  ),
                  child:Row(
                    children: <Widget>[
                      Icon(Icons.arrow_back),
                      SizedBox(width: 15,),
                      translations.currentLanguage=='en'?
                      Text("determine your Order Location"):
                      Text("اخـتـر موقع توصيل الطـلـب"),
                    ],
                  ),
                  color: Color(0XFF21d493),
                  onPressed: () {
                    Navigator.pop(context,object);
                  },

                ),
              ),

              /// pin mark on where my device Location
              Center(
                child: Icon(
                  Icons.near_me,
                  size: 25.0,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

}
