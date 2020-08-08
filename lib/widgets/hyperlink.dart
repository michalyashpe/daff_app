import 'package:daff_app/helpers/style.dart';
import 'package:flutter/material.dart';

Widget buildHyperLink({String text, Function onPressed}) {
  return GestureDetector(
      onTap: onPressed, child: Text(text, style: hyperlinkStyle));
}
