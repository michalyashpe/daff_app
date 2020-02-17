import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildIcon(String iconUrl){
  return Container(
    height: 40.0,
    width: 40.0,
    alignment: Alignment.center,
    padding: EdgeInsets.all(7.0),
    decoration: BoxDecoration(
      border: Border.all(width: 2.5),
      shape: BoxShape.circle,
    ),
    child: SvgPicture.asset(iconUrl, width: 20.0,),
  );
}