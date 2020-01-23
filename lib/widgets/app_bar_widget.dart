import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget buildAppBarWidget(){
  return AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
          Text('הדף'),
          SizedBox(width: 10.0,),
          Text('מדורת שבט לכתיבה יוצרת', style: TextStyle(fontSize: 15.0),)
        ],),
        leading: SvgPicture.asset(
          'assets/logo.svg',
          semanticsLabel: 'Acme Logo'
        ),
        automaticallyImplyLeading: false,
      );
}