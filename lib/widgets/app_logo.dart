import 'package:daff_app/helpers/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildAppLogo(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
      
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/logo.svg',
            width: 20.0,
            semanticsLabel: 'Acme Logo'
          ),
          SizedBox(width: 10.0,),
          Text(fullAppSlogen , style: TextStyle(fontSize: 20.0, letterSpacing: 0.0, fontWeight: FontWeight.bold)),
        ]
      ),
      // Divider()
    ],);
  }