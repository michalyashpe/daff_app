 import 'package:flutter/material.dart';

Widget buildAllRights({String gender = 'they'}){
  String rightsText;
  if (gender == 'male') 
    rightsText = 'כל הזכויות שמורות למחבר כפרה עליו ';
  else if (gender == 'femle') 
    rightsText = 'כל הזכויות שמורות למחברת המהממת ';
  else 
    rightsText = 'כל הזכויות שמורות למחברים ולמחברות ';
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(rightsText),
      Icon(Icons.copyright, size: 15.0),
      Text( ' ' + DateTime.now().year.toString())
  ],);
}