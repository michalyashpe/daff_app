import 'package:daff_app/authentication_model.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final User user;
  WelcomeScreen(this.user);
  
  @override
  Widget build(BuildContext context) {
    print(user.gender);
    String receive = user.gender == 'female' ? 'תקבלי': 'תקבל';
    return Scaffold(
      appBar: AppBar(
        title: Text('ברוכים הבאים'),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Text('הי ${user.name}, התחברת בהצלחה :)',
            textAlign: TextAlign.right,
            style:  TextStyle(fontSize: 18.0,),
          ),
          Text('איזה כיף, מעכשיו $receive עדכון בכל פעם שסיפור חדש יוצא.',
            textAlign: TextAlign.right,
            style:  TextStyle(fontSize: 18.0),
          )
        ],)
      )
        
    );
  }
}