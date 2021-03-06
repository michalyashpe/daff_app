import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:transparent_image/transparent_image.dart';

Widget buildAvatarImage(String imageUrl, {double height = 80.0}) {
  return ClipOval(
      child: Container(
          height: height,
          child: imageUrl.split(".").last == 'svg'
              ? SvgPicture.network(imageUrl)
              : FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  fadeInDuration: Duration(milliseconds: 200),
                  image: imageUrl)));
}
