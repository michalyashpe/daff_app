import 'dart:async';

import 'package:daff_app/helpers/style.dart';
import 'package:daff_app/screens/stories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    delaySplashScreen();
  }

  Future<Timer> delaySplashScreen() async {
    return Timer(
      Duration(milliseconds: 1500), 
      () async => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => StoriesScreen('בית', 'hits=true')))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Container(
        alignment: Alignment.center,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('assets/logo.svg',),
          Text(fullAppSlogen, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold))
        ]
      ),
    ));
  }
}
