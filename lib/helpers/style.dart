import 'package:flutter/material.dart';

TextStyle h1 = TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold);
TextStyle h2 = TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);
TextStyle h5 = TextStyle(fontSize: 22.0);
TextStyle h5bold = h5.merge(TextStyle(fontWeight: FontWeight.bold));
TextStyle h5grey = TextStyle(fontSize: 22.0, color: Colors.grey);
TextStyle appBarTitle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

TextStyle hyperlinkStyle =
    TextStyle(color: Colors.blueGrey, decoration: TextDecoration.underline);

double storyPreviewLineHeight = 5.0;

String appSlogen = 'במה ליצירה עצמאית';
String appName = 'הַדַּף';
String fullAppSlogen = '$appName - $appSlogen';

double socialBarHeight = 60.0;

double playerHeight = 60.0;
double sliderHeight = 4.0;
double playerWidgetHeight = playerHeight + sliderHeight;

Color socialBoxBackgroundColor = Colors.grey[200];
Color socialBoxIconsColor = Colors.grey[600];
