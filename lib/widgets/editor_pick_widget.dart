import 'package:daff_app/models/story.dart';
import 'package:flutter/material.dart';

Widget buildEditerPickMedalWidget(Story story){
  return story.editorPick ? Image.asset('assets/medal.png', width: 20.0,) : Text(''); 
}