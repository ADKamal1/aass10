import 'package:cached_network_image/cached_network_image.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/screens/home_page/widgets/userRating.dart';
import 'package:basket/utils/size_config.dart';
import 'review_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'mainInfo-widget.dart';

class ProudectProfileWidget extends StatefulWidget {

  List<UserRating> ratingList = <UserRating>[];
  Product currentProduct;

  ProudectProfileWidget({ this.currentProduct ,this.ratingList});
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProudectProfileWidget> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;


//  refresh(){
//  setState(() {
//
//  });
//}


  @override
  void initState() {
    // TODO: implement initState
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 1);
    _tabController.addListener(_handleTabSelection);
     if(mounted)
       setState(() {

       });
  }

  _handleTabSelection() {
    setState(() {

    });
  }
  void list(){}

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return ListView(
        physics: ScrollPhysics(),
        children: <Widget>[
      Container(
        color: Color.fromRGBO(33, 212, 147, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FittedBox(
                  fit: BoxFit.cover,
                  child: Container(
                    margin: EdgeInsets.only(top:15,bottom: 5),
                    height: SizeConfig.getResponsiveHeight(140.0),
                    width: SizeConfig.getResponsiveWidth(200.0),
                    child: SizedBox(
                      width: double.infinity,
                      child:
                      CachedNetworkImage(
                        placeholder: (context, url) => const AspectRatio(
                          aspectRatio: 1.6,
                        ),
                        imageUrl:widget.currentProduct.photo,
                        fit: BoxFit.cover,
                      ),
                    ),

                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom:5.0),
                      child: Text(translations.currentLanguage=='en'? widget.currentProduct.title:
                          widget.currentProduct.arabicTitle,
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),

      new TabBar(
        labelColor: Color.fromRGBO(33, 212, 147, 1),
        controller: _tabController,
        indicatorColor: Color.fromRGBO(33, 212, 147, 1),
        tabs: [
          new Tab(
              child: new Text(
            translations.text("ProductProfiletPage.tabAllRating"),
            style: TextStyle(
                color: Color.fromRGBO(33, 212, 147, 1),
                fontSize: 15.0,
                fontWeight: FontWeight.bold),
          )),
          new Tab(
            child: new Text(translations.text("ProductProfiletPage.tabAllMainInformation"),
                style: TextStyle(
                    color: Color.fromRGBO(33, 212, 147, 1),
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),

      //TODO fix the widget to be flexable size..
      new Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height - 320,
        child: new TabBarView(
          controller: _tabController,
          children: <Widget>[
            (widget.ratingList.length == 0)?  Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 15.0),
                child: Text(translations.text("ProductProfiletPage.AllRatingPage.NoRatingText")),),):
            new ListView.builder(
                physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.ratingList.length,
              itemBuilder: (BuildContext ctxt, int index) {
              return  Column(
         mainAxisAlignment: MainAxisAlignment.end,
         children: <Widget>[
           reviewWidget(
             name: widget.ratingList.elementAt(index).customer.name,
             review:   (widget.ratingList.elementAt(index).rating.comment == null)?
             Text(translations.text("ProductProfiletPage.AllRatingPage.NoCommentText")):
             widget.ratingList.elementAt(index).rating.comment,
             image: AssetImage("assets/images/pro.png"),
             ratingValue: (widget.ratingList.elementAt(index).rating.rating == null)?0:widget.ratingList.elementAt(index).rating.rating,
           ),
           Divider(
             indent: 25,
             color: Colors.black12,
             endIndent: 25,
           ),
           SizedBox(
             height: 7.0,
           ),

         ],
       );

    }),
            Container(
                padding: EdgeInsets.only(bottom: 0),
                child:new MainInfo(
                name: translations.currentLanguage=='en'?widget.currentProduct.title:widget.currentProduct.arabicTitle,
                price: widget.currentProduct.price.toString(),
                quantity: translations.currentLanguage=='en'?widget.currentProduct.englishQuantityType:widget.currentProduct.arabicQuantityType,
                details: translations.currentLanguage=='en'?widget.currentProduct.description:widget.currentProduct.arabicDescription))
          ],
        ),
      ),
    ]);
  }
}
