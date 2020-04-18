import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildIcon(String iconUrl, {double height = 30.0}){
  return Container(
    height: height,
    width: height,
    alignment: Alignment.center,
    padding: EdgeInsets.all(6.0),
    decoration: BoxDecoration(
      border: Border.all(width: 2.0),
      shape: BoxShape.circle,
    ),
    child: SvgPicture.asset(iconUrl, width: height / 2,),
  );
}