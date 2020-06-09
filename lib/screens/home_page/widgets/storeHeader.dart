import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/screens/home_page/widgets/SearchProudect.dart';
import 'package:basket/utils/size_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';

class StoreHeader extends StatefulWidget{

  _StoreHeader createState()=>_StoreHeader();

}

class _StoreHeader extends State<StoreHeader> {

  FirebaseDatabase _database = FirebaseDatabase.instance;
  List<String> proNAme= new List<String>();


  getAllProducts() async{
    productList.clear();
    // get the products
    await _database.reference().child("products").once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> productsMap = snapshot.value;
      productsMap.forEach((key, value) async{
        Product p = Product.fromMap(value , key);
        proNAme.add(p.title);
        proNAme.add(p.arabicTitle);
      });
    }).then((v) {
      if (mounted) setState(() {});
    });



  }

  ///- to search about product
  Future<void> getSearchProudect (BuildContext context , String searchProductNAme) async {

    //translations.currentLanguage=='en'?
    await _database.reference().child("products")
        .orderByChild("title").equalTo(searchProductNAme)
        .once()
        .then((DataSnapshot snapshot){
      Map<dynamic,dynamic> proudectSearch = snapshot.value;
      proudectSearch.forEach((key,value)async{
        Product pro = Product.fromMap(value, key);
        //pro.stockQuantity==null?Container():
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) =>
            new searchProduct(pro.productId)));

      });if (mounted) setState(() {});
    }).whenComplete((){
       _database.reference().child("products")
          .orderByChild("arabicTitle").equalTo(searchProductNAme)
          .once()
          .then((DataSnapshot snapshot){
        Map<dynamic,dynamic> proudectSearch = snapshot.value;
        proudectSearch.forEach((key,value)async{
          Product pro = Product.fromMap(value, key);
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) =>
              new searchProduct(pro.productId)));

        });if (mounted) setState(() {});
      });
    });



  }

  List<Product> productList = <Product>[];

  @override
  void initState() {
    super.initState();
    getAllProducts();
  }


  ////- latitude and longitude for store Location
  double onMoveLatitude = 21.58969;
  double onMoveLongitude= 39.22006;
  /// to open google maps in determined Location
  static Future<void> openGoogleMapApp({double latitude, double longitude}) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
      print('opnenig');
    } else {
      throw 'Could not open the map.';
    }}

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
          children: <Widget>[
            Container(
              height: SizeConfig.getResponsiveHeight(94.0),
              decoration: BoxDecoration(
                  color: Color(0XFF21d493),
                  borderRadius: BorderRadius.only(
                      bottomLeft:
                      Radius.circular(SizeConfig.getResponsiveWidth(20.0)),
                      bottomRight:
                      Radius.circular(SizeConfig.getResponsiveWidth(20.0)))),
            ),
            GestureDetector(
              onTap: (){
                openGoogleMapApp(latitude: onMoveLatitude,longitude: onMoveLongitude);
              },
              child: Center(
                  child:Container(
                    width: SizeConfig.getResponsiveWidth(230.0),
                    height: SizeConfig.getResponsiveWidth(30.0),
                    color: Colors.white70,
                    margin:
                    EdgeInsets.only(bottom: SizeConfig.getResponsiveHeight(5.0)),
                    child: Center(
                        child:Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.location_on,color: Color(0XFF21d493),),
                            SizedBox(width: 5,),
                            Text(translations.text("StorePage.StoreHeaderlocation"),
                              style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        )
                    ),
                  )
              ),

            ),

            Positioned(
              bottom: SizeConfig.getResponsiveHeight(8),
              left: SizeConfig.getResponsiveWidth(35.0),
              child: GestureDetector(
                onTap: (){
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Search()));
                  //showSearch(context: context, delegate: DataSearch());
                  showSearch(context: context, delegate: DataSearch(this,proNAme));
                },
                child: Container(
                  width: SizeConfig.getResponsiveWidth(300.0),
                  height: SizeConfig.getResponsiveHeight(30.0),
                  color: Colors.white70,
                  margin:
                  EdgeInsets.only(bottom: SizeConfig.getResponsiveHeight(10.0)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.search,color: Color(0XFF21d493),),
                      SizedBox(width: 5,),
                      Text(translations.text("StorePage.StoreHeaderSearchHint"),
                        style: TextStyle(fontWeight: FontWeight.bold),),
                    ],

                  ),
                ),
              ),
            )
          ],
        ));
  }

}

class DataSearch extends SearchDelegate<String>{
  final _Search ;
  List<String> _productList;
  DataSearch(this._Search,this._productList);


  final recentProducts = [
    "Banana",
    "طماطم",
    "Tomato2",
    "جزر",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    ///- Actions For AppBar
    return [IconButton(icon: Icon(Icons.clear),onPressed: (){
      query="";
    },)];
  }

  @override
  Widget buildLeading(BuildContext context) {
    ///- leading Icon on left of appBar
    return IconButton(
      icon: AnimatedIcon(
        icon:AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },);
  }

  @override
  Widget buildResults(BuildContext context) {
    ///- Show some Results based on the Selection
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        child: Card(
          color: Colors.green,
          child: Center(
            child: Text(query),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //StoreHeader ob = new StoreHeader();
    ///- Show when someone Searches for Somethings
    ///query[0].toUpperCase() to make Frist letter user ener it Capital and other leeters not capital not important
    ///but that frist letter is capital is imprtant
    //String s = _productList.contains(query[0].toUpperCase().contains(query[0].toLowerCase())).toString();
    final suggestionList = query.isEmpty
        ?recentProducts
        :_productList.where((p)=>p.toLowerCase().startsWith(query.toLowerCase())).toList();
       // query[0].toUpperCase().toString().contains(query[0].toLowerCase()).toString())).toList();
    //Products.where((p)=>p.startsWith(query[0].toUpperCase())).toList();
    return ListView.builder(
      itemBuilder: (context,index)=>ListTile(
        onTap: (){
          //showResults(context);
          //print("\n\n\n");
          //print(suggestionList[index].toString());
          _Search.getSearchProudect(context,suggestionList[index].toString());



        },
        leading: Icon(Icons.search),
        title: RichText(
          text:TextSpan(
              text: suggestionList[index].substring(0,query.length),
              style: TextStyle(
                  color: Colors.black,fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: suggestionList[index].substring(query.length),
                  style: TextStyle(
                      color: Colors.grey),
                )]
          ),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }

}



