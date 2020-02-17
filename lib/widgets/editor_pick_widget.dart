import 'package:daff_app/models/story.dart';
import 'package:flutter/material.dart';

Widget buildEditerPickMedalWidget(Story story, {bool bigSize = false}){
  return story.editorPick ? Image.asset('assets/medal.png', width: bigSize ? 30.0: 20.0,) : Text(''); 
}