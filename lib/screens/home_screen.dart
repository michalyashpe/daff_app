import 'package:daff_app/authentication_model.dart';
import 'package:daff_app/helpers/firebase_api.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  HomeScreen(this.user);
  
  @override
  Widget build(BuildContext context) {
    return notificationUrl != '' ? StoryScreen() : Scaffold(
      appBar: AppBar(
        title: Text('ברוכים הבאים'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildWelcomeMessage(),
        ],)
      )
        
    );
    }

    Widget _buildWelcomeMessage(){
      String receive = user.gender == 'female' ? 'תקבלי': 'תקבל';
      return Column(
        children: <Widget>[
        Text('הי ${user.name}, התחברת בהצלחה :)',
          textAlign: TextAlign.right,
          style:  TextStyle(fontSize: 18.0,),
        ),
        Text('איזה כיף, מעכשיו $receive עדכון בכל פעם שסיפור חדש יוצא.',
          textAlign: TextAlign.right,
          style:  TextStyle(fontSize: 18.0),
        )
      ],);
  }
}