import 'package:daff_app/widgets/shimmering_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget buildAvatarImage(String imageUrl, {bool loading = false}){
  print(imageUrl);
  return ClipOval(
        // radius: 20.0,
    child: loading 
    ? buildShimmeringBox(height: 80, width: 80)
    : Container(
      height: 80.0,
      child: imageUrl.split(".").last == 'svg' ? 
        SvgPicture.network(imageUrl) 
        : Image.network(imageUrl)
    ));
  }