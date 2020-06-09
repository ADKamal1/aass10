import 'package:basket/Providers/products.dart';
import 'package:basket/_model/Product_Offer.dart';
import 'package:basket/_model/categories.dart';
import 'package:basket/screens/home_page/my_Basket.dart';
import 'package:basket/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryProducts extends StatefulWidget {
  //String categoryId;
  //List<Product> categoryItems = <Product>[];
  String categoryName;
  categories category;

  List<Product_Offer> productsForOffer = <Product_Offer>[];
  CategoryProducts({this.category, this.categoryName, this.productsForOffer});
  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  //FirebaseDatabase _database = FirebaseDatabase.instance;
  //List<Product> categoryItems = <Product>[];

  String nodeName = "product";
  String nodeCategory = "category";

  var _isInit = true;
  var _isLoading = false;

  // List<Product> productList = <Product>[];
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context)
          .getListProductOfSpecificCategory(widget.category.categoryID)
          .then((_) {
        setState(() {
          _isLoading = false;
          // dispose();
        });
      });
//      dispose();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("\n\n + aaa ");
    final productsData = Provider.of<Products>(context);

    final categoryItems = productsData.categoryitems;

    print("\n\n +bbb" + categoryItems.length.toString());

    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.categoryName),
        backgroundColor: Color(0XFF21d493),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return Container(
              child: new ListView(children: <Widget>[
            // adding the listview here...

            Container(
              margin:
                  EdgeInsets.only(bottom: SizeConfig.getResponsiveHeight(0.0)),
              child: GridView.count(
                mainAxisSpacing: SizeConfig.getResponsiveHeight(0),
                shrinkWrap: true,
                physics: ScrollPhysics(),
                childAspectRatio: 1.0,
                crossAxisSpacing: SizeConfig.getResponsiveWidth(0.0),
                crossAxisCount:
                    MediaQuery.of(context).size.width >= 540 ? 3 : 2,
                children: List.generate(categoryItems.length, (ind) {
                  int productOffer =
                      ifProductHaveOffer(categoryItems[ind].productId);
                  if (productOffer == -1) {
                    // product has no offer
                    return makeProductCard(categoryItems[ind], false, 0.0);
                  } else {
                    // product has an offer
                    double newPrice = categoryItems[ind].price *
                        (widget.productsForOffer
                                .elementAt(productOffer)
                                .offer
                                .rate /
                            100);
                    return makeProductCard(categoryItems[ind], true, newPrice);
                  }
                }),
              ),
            )
          ]));
        });
      }),
    );
  }

  // if the product has offer it will return the id else will return -1
  int ifProductHaveOffer(String productID) {
    for (int i = 0; i < widget.productsForOffer.length; i++) {
      if (widget.productsForOffer.elementAt(i).product.productId == productID) {
        return i;
      }
    }
    return -1;
  }

//  aaa async()
//  {
//    await categoryItems = Provider.of<Products>(context) as List<Product>;
//  }

  Future<void> _refreshProducts(BuildContext context) async {
    print("\n\n\n + id : ");
    //print(widget.categoryId.toString());
    await Provider.of<Products>(context)
        .getListProductOfSpecificCategory(widget.category.categoryID);
    dispose();
  }

  @override
  void initState() {
//
//    Provider.of<Products>(context).getListProductOfSpecificCategory(widget.categoryId).then((_) {
//      setState ( () {
//        _isLoading = false;
//      } );
//    });
    // get the products
//    _database.reference().child("product").once().then((DataSnapshot snapshot) {
//      Map<dynamic, dynamic> productsMap = snapshot.value;
//      productsMap.forEach((key, value) {
//        if(key == widget.categoryId)
//            productList.add(Product.fromMap(value, key));
//      });
//    }).then((v) {
//      print("from details = " + productList.length.toString());
//      if (mounted) setState(() {});
//    });

//    _database
//        .reference()
//        .child(nodeName)
//        .child("categories")
//        .child(widget.categoryName)
//        .onChildAdded
//        .listen(_childAdded);
//    _database
//        .reference()
//        .child(nodeName)
//        .child("categories")
//        .child(widget.categoryName)
//        .onChildRemoved
//        .listen(_childRemoves);
//    _database
//        .reference()
//        .child(nodeName)
//        .child("categories")
//        .child(widget.categoryName)
//        .onChildChanged
//        .listen(_childChanged);
    super.initState();

    _refreshProducts(this.context);
  }

//  /// for the category.
//  _childAdded(Event event) {
//    setState(() {
//      productList
//          .add(Product.fromSnapshot(event.snapshot, widget.categoryName));
//    });
//  }
//
//  void _childRemoves(Event event) {
//    var deletedPost = productList.singleWhere((post) {
//      return post.key == event.snapshot.key;
//    });
//
//    setState(() {
//      productList.removeAt(productList.indexOf(deletedPost));
//    });
//  }
//
//  void _childChanged(Event event) {
//    var changedPost = productList.singleWhere((post) {
//      return post.key == event.snapshot.key;
//    });
//
//    setState(() {
//      productList[productList.indexOf(changedPost)] =
//          Productt.fromSnapshot(event.snapshot, widget.categoryName);
//    });
//  }
//
//  Widget makeProductCard(Product productItem) {
//    return InkWell(
//        onTap: () {
//          Navigator.of(context).push(new MaterialPageRoute(
//              builder: (context) => new productDetails(productItem)));
//        },
//        child: Container(
////    height: SizeConfig.getResponsiveHeight(60.0),
////    width: SizeConfig.getResponsiveWidth(70.0),
//          child: FittedBox(
//              fit: BoxFit.contain, child: product_card(product: productItem)),
//        ));
//  }
}
