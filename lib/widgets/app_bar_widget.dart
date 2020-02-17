import 'dart:ui';

import 'package:daff_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildAppBarWidget(BuildContext context ,{bool backButton = true}){
  return AppBar(
    // elevation: 0.0,
    // backgroundColor: Colors.white10,
    backgroundColor: Colors.white,
    title: GestureDetector(
      onTap: ()  => Navigator.of(context).pushNamed(HomeScreen.routeName,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SvgPicture.asset(
            'assets/logo.svg',
            width: 45.0,
            semanticsLabel: 'Acme Logo'
          ),
          SizedBox(width: 10.0,),
          Text('הַדַּף', style: TextStyle(fontSize: 35.0, fontFamily: GoogleFonts.alef().fontFamily)),
        ]),
    ),
    actions: <Widget>[
      backButton ? IconButton(icon:Icon(Icons.arrow_forward),
        onPressed:() => Navigator.pop(context, false),
      ) : Text('')
    ],
    automaticallyImplyLeading: false,
  );
}