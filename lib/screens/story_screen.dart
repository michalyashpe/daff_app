import 'package:daff_app/helpers/firebase_api.dart';
import 'package:flutter/material.dart';

class StoryScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('story screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('this is a story'),
            Text(notificationUrl),
        ],)
      )
        
    );
  }
}