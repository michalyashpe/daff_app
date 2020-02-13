import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget buildAvatarImage(String imageUrl){
  return ClipOval(
        // radius: 20.0,
    child: Container(
      height: 80.0,
      child: imageUrl.split(".").last == 'svg' ? 
        SvgPicture.network(imageUrl) 
        : Image.network(imageUrl)
    ));
  }