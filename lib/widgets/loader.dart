import 'package:flutter/material.dart';

Widget buildLoader({EdgeInsets margin, Color color = Colors.white}){
  if (margin == null) margin = EdgeInsets.all(10.0);
  return Container(
    margin: margin,
    width: 16.0,
    height: 16.0, 
    child: CircularProgressIndicator(
      backgroundColor: color,
      strokeWidth: 2.0,
    )
  ) ;
}