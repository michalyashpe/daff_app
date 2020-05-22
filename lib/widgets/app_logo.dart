import 'package:daff_app/helpers/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildAppLogo() {
  return Column(
    // crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/logo.svg',
                width: 30.0, semanticsLabel: 'Acme Logo'),
            SizedBox(
              width: 10.0,
            ),
            Text(fullAppSlogen,
                style: TextStyle(
                    fontSize: 25.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal)),
          ]),
      // Divider()
    ],
  );
}

Widget buildLineLogo(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      SvgPicture.asset('assets/logo.svg',
          width: 40.0, semanticsLabel: 'Acme Logo'),
      SizedBox(
        width: 10.0,
      ),
      Text(fullAppSlogen,
          style: TextStyle(
              fontSize: 17.0,
              // letterSpacing: -0.5,
              fontWeight: FontWeight.normal)),
    ]);
}
Widget buildAppLogoLarge() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.end, 
        children: <Widget>[
          SvgPicture.asset('assets/logo.svg',
              width: 45.0, semanticsLabel: 'Acme Logo'),
          SizedBox(width: 10.0,),
          Text(appName, style: TextStyle(fontSize: 35.0,)),
          
        ]),
        Text(appSlogen, style: TextStyle(fontSize: 20.0))
      ]);
}
