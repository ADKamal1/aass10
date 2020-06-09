import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/utils/size_config.dart';

class registrationLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34 * SizeConfig.heightMultiplier,
      width: MediaQuery.of(context).size.width,
      color: Color(0xff21d493),
      child: Container(
        margin: EdgeInsets.only(
            bottom:
                (SizeConfig.isPortrait ? 8 : 15) * SizeConfig.heightMultiplier),
        alignment: Alignment.center,
        child: Image.asset("assets/images/logo.png",width: 180,height: 180,)
      ),
    );
  }
}
