import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildConnectUpButton({String text, IconData iconData, Function onPressed }){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[ 
        Expanded( 
          child: RaisedButton(
            padding: EdgeInsets.all(10.0),
            onPressed: onPressed, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
              FaIcon(iconData, size: 22.0),
              SizedBox(width: 10.0,),
              Text(text, style: TextStyle(fontSize: 20.0))
            ],)
          )
        )
      ]);
  }