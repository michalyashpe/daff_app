import 'dart:async';
import 'package:daff_app/helpers/html_helper.dart';
import 'package:daff_app/helpers/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RedirectingScreen extends StatefulWidget {
  final String url;
  RedirectingScreen(this.url);
  @override
  State<StatefulWidget> createState() {
    return RedirectingScreenState();
  }
}

class RedirectingScreenState extends State<RedirectingScreen> {
  @override
  void initState() {
    super.initState();
    delayRedirectingScreen();
  }

  Future<Timer> delayRedirectingScreen() async {
    return Timer(Duration(milliseconds: 1700), () async {
      await HtmlHelper.launchURL(widget.url);
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      alignment: Alignment.center,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/logo.svg',
            ),
            Text(fullAppSlogen,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'הנכם מועברים לאתר...\n\n *בקרוב אפשר יהיה לעשות את זה באפליקציה. כן. גם לנו קשה לחכות. ',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            )
          ]),
    ));
  }
}
