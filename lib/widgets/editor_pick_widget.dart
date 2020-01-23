import 'package:daff_app/models/stories_model.dart';
import 'package:flutter/material.dart';

Widget buildEditerPickMedalWidget(Story story){
  return story.authorPick ? Image.asset('assets/medal.png', width: 20.0,) : Text(''); 
}