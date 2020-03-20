import 'package:daff_app/models/story.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:transparent_image/transparent_image.dart';

Widget buildAvatarImage(Story story){
  return ClipOval(
    child: Container(
      height: 80.0,
      child: story.author.imageUrl.split(".").last == 'svg' ? 
        SvgPicture.network(story.author.imageUrl) 
        : FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            fadeInDuration: Duration(milliseconds: 200),
            image: story.author.imageUrl
          )
    ));
  }