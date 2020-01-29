import 'package:daff_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget buildAppBarWidget(BuildContext context){
  return AppBar(
    backgroundColor: Colors.white,
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          onTap: ()  => Navigator.of(context).pushNamed(HomeScreen.routeName,),
          child: Text('הַדַּף'),
        ),
      SizedBox(width: 10.0,),
      // Text('מדורת שבט לכתיבה יוצרת', style: TextStyle(fontSize: 15.0),)
    ],),
    leading: SvgPicture.asset(
      'assets/logo.svg',
      semanticsLabel: 'Acme Logo'
    ),
    actions: <Widget>[
      IconButton(icon:Icon(Icons.arrow_forward),
        onPressed:() => Navigator.pop(context, false),
      )
    ],
    automaticallyImplyLeading: false,
  );
}