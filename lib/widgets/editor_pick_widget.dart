import 'package:daff_app/models/story.dart';
import 'package:flutter/material.dart';

Widget buildEditerPickMedalWidget(Story story, {double size = 20.0}){
  return story.editorPick ? 
    Padding(
      // alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Image.asset('assets/medal.png', width: size, height: size )
    )
     : Text(''); 
}