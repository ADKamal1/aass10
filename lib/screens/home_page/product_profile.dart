import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/customers.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/_model/rating.dart';
import 'package:basket/screens/home_page/widgets/userRating.dart';
import 'widgets/proudect_profile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class productProfile extends StatefulWidget {
  Product currentProduct;
  final Function() notifyParent;
  productProfile({this.currentProduct  , Key key   , @required this.notifyParent}):super(key:key);
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<productProfile> {
  bool isAuthenticated = false;
  refresh(){
    if(mounted)
    setState(() {

    });
  }
  List<UserRating> ratingList = <UserRating>[];
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String customerID;

  void loadUserRating() async {
    ratingList.clear();
    await _database
        .reference()
        .child("rating")
        .onChildAdded
        .listen(_ratingChildAdded);

    if(mounted)
      setState(() {

      });

  }
  _ratingChildAdded(Event event)async{
    Map<dynamic, dynamic> categoryMap = event.snapshot.value;
    UserRating userRating = new UserRating();
    await _database
        .reference()
        .child("customers")
        .child(event.snapshot.value["customerID"])
        .once()
        .then((DataSnapshot snapshot) {
      customers nextCustomer = customers.fromSnapshot(snapshot);
      userRating.customer = nextCustomer;
    });

    ratings rating = ratings.fromMap(event.snapshot.value, event.snapshot.key);
    userRating.rating = rating;
    if (widget.currentProduct.productId == userRating.rating.productID)
      ratingList.add(userRating);
    if(mounted)
      setState(() {

      });
  }

  getUserId() async{
   await FirebaseAuth.instance.currentUser().then((user) async{
      if(user != null){
        customerID = user.uid;
        isAuthenticated = true;
      }
    }).whenComplete((){
      if(mounted){
        setState(() {

        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadUserRating();
    getUserId();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: new Container(),
        ),
        body: Stack(
          children: <Widget>[
            new ProudectProfileWidget(
              currentProduct: widget.currentProduct,
              ratingList: ratingList,
            ),
       Align(
          alignment: Alignment.bottomCenter,
         child:Card(color:Color.fromRGBO(33, 212, 147, 1),
           elevation:5,
           child: RaisedButton(
           onPressed: () {
             //// - must check frist if (customer not Login can not add Comment or rate for Proudect)
             if(isAuthenticated == true){
               _showCupertinoDialog(context);
             }else
               {
                 _showDialogFrist(context);
               }


           },
           color: Color.fromRGBO(33, 212, 147, 1),
           textColor: Colors.white,
           child: Text(
             translations.text("ProductWidgetPage.ProductRateing"),
             overflow: TextOverflow.visible,
             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
           ),
         ),)
       )
          ],
        ));
  }

  void _showCupertinoDialog(BuildContext context) {
    final myController = TextEditingController();
    double rating = 0;
    bool published = false;
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(translations.text("ProductWidgetPage.ProductRateing")),
            content: new Column(
              children: <Widget>[
                SizedBox(
                  height: 5.0,
                ),
                FlutterRatingBar(
                  initialRating: 0,
                  itemSize: 40.0,
                  fillColor: Colors.amber,
                  borderColor: Colors.amber,
                  allowHalfRating: true,
                  onRatingUpdate: (rat) {
                    rating = rat;
                  },
                  textDirection: translations.currentLanguage=='en'?TextDirection.ltr:TextDirection.rtl,
                ),
              ],
            ),
            actions: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0, right: 10.0, left: 10.0),
                    child: Card(
                      color: Color.fromRGBO(33, 212, 147, 1),
                      elevation: 0.0,
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: myController,
                            minLines: 5,
                            maxLines: 15,
                            textAlign:translations.currentLanguage=='en'? TextAlign.left:TextAlign.right,
                            decoration: InputDecoration(
                                hintText: translations.text("ProductWidgetPage.ProductComment"),
                                filled: true,
                                fillColor: Colors.black12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(5.0),
                      child: FlatButton(
                        color: Color.fromRGBO(33, 212, 147, 1),
                        onPressed: () {
                          // TODO
                          String text = myController.text.toString();
                          if(rating != 0 || text.trim().length != 0){
                       print("\n\ncustomer id = "  + customerID.toString());
                         if(customerID != null){
                           published = true;
                               _database.
                               reference()
                                   .child("rating").push()
                                   .set({
                                 "comment": text,
                                 "customerID":customerID,
                                 "isApproved":"true",
                                 "productID":widget.currentProduct.productId,
                                 "rating":rating
                               }).then((v){
                                 if(mounted)
                                   setState(() {

                                   });
                               });
                             }else{
                               print("false");
                             }
                         }

                          _dismissDialog(context);

                          if(published == true)
                          _scaffoldKey.currentState.showSnackBar(SnackBar(content:(translations.currentLanguage == 'ar')?Text('لقد تم نشر تعليقك بنجاح'):Text('Successfly adding Rating')));
                        },
                        child: Container(
                            child: Text(translations.text("ProductWidgetPage.ProductRateingText"),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0,
                                    color: Colors.white))),
                      )),
                ],
              )
            ],
          );
        });
  }

  ///--- this alert Dialog to tell customer that no Rating or comment if (he not log In)
  void _showDialogFrist(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                    child: Icon(Icons.tag_faces,color: Colors.black,),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Text(translations.text("ProductProfiletPage.AllRatingPage.thatNoRatingAlert"),
                    style: TextStyle(fontSize: 18.0),
                  ), /////////localiz
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: Color.fromRGBO(33, 212, 147, 1),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          child:
                          translations.currentLanguage=='ar'?
                          Text("حــــسـنـــــاً"):
                          Text( 'OK',
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
        });
  }

}

_dismissDialog(BuildContext context) {
  Navigator.pop(context);
}


