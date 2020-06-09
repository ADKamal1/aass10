import 'package:flutter/material.dart';
import 'package:basket/utils/size_config.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: bottomNavigationBar(),
    );
  }
}

Widget bottomNavigationBar() {
  return ClipRRect(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(40),
      topLeft: Radius.circular(40),
    ),
//    child: BottomNavigationBar(
//      elevation: 50.0,
//      backgroundColor: Colors.white,
//      items: [
//        /////- Offers where in that item ?!!
//        bottomNavigationBarItem(
//            "assets/images/sala.png", "assets/images/salaActive.png", "Store"),
//        bottomNavigationBarItem("assets/images/mycard-icon.png",
//            "assets/images/mycard-icon.png", "My Cart" ),
//        bottomNavigationBarItem("assets/images/heardw.png",
//            "assets/images/heartActive.png", "Favourite"),
//        bottomNavigationBarItem("assets/images/profile.png",
//            "assets/images/profile.png", "Profile")
//      ],
//      onTap: (index) {},
//      unselectedItemColor: Colors.black,
//      selectedItemColor: Colors.green,
//      showUnselectedLabels: true,
//    ),
  );
}

BottomNavigationBarItem bottomNavigationBarItem(
    String imagePath, String imageActive, String title ) {
  return BottomNavigationBarItem(
      activeIcon: new Container(
          height: SizeConfig.getResponsiveHeight(25.0),
          width: SizeConfig.getResponsiveHeight(25.0),
          child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset(
                imageActive,
                width: SizeConfig.getResponsiveHeight(20),
                color: Colors.green,
                height: SizeConfig.getResponsiveHeight(20),
              ))),
      icon: new Container(
          height: SizeConfig.getResponsiveHeight(20.0),
          width: SizeConfig.getResponsiveHeight(20.0),
          child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset(imagePath,
                  width: SizeConfig.getResponsiveHeight(20),
                  height: SizeConfig.getResponsiveHeight(20)))),
      title: Text(title,
          style: TextStyle(fontSize: SizeConfig.getResponsiveWidth(11.0))));
}
