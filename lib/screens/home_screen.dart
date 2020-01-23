import 'package:daff_app/authentication_model.dart';
import 'package:daff_app/helpers/firebase_api.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  HomeScreen(this.user);
  
  @override
  Widget build(BuildContext context) {
    return notificationUrl != '' ? StoryScreen() : Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
          Text('הדף'),
          SizedBox(width: 10.0,),
          Text('מדורת שבט לכתיבה יוצרת', style: TextStyle(fontSize: 15.0),)
        ],),
        leading: SvgPicture.asset(
          'assets/logo.svg',
          semanticsLabel: 'Acme Logo'
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // _buildWelcomeMessage(),
            _buildLastWeekStories()
        ],)
      )
        
    );
    }

    Widget _buildLastWeekStories(){
      return Column(children: <Widget>[
        _buildStoryPreview(),
      ],);
    }

    Widget _buildStoryPreview(){
      return Container( 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.grey[100],
        ),
        padding: EdgeInsets.all(5.0),
        child: Row(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0))
          ),
          child: GestureDetector(
            onTap: () {
              StoryScreen();
            },
            child: Image.network( //story image
              'https://ik.imagekit.io/g3jrzlo0a/tr:w-800,h-/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBcVFIIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--d0bcc7a6455d7df2a120c33f3b593f38362619b3/RackMultipart20200122-7455-q0pjra.png',
              width: 170.0,
            )
          )
        ),
        SizedBox(width: 10.0,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              Text('העניין עם געגוע', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)), //story title
              Image.asset('assets/medal.png', width: 20.0,), //editor pick
              Text(', '),
            ],),
            Text('עוז פרנקל', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)), //author name
            Text('דקת קריאה'),
            _buildTag('שירה'),
            Text('22 לינואר')

        ],)

      ],));
    }

    Widget _buildTag(String name){
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.grey[300],
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Text(name)
      );
    }





    // Widget _buildWelcomeMessage(){
    //   String receive = user.gender == 'female' ? 'תקבלי': 'תקבל';
    //   return Column(
    //     children: <Widget>[
    //     Text('הי ${user.name}, התחברת בהצלחה :)',
    //       textAlign: TextAlign.right,
    //       style:  TextStyle(fontSize: 18.0,),
    //     ),
    //     Text('איזה כיף, מעכשיו $receive עדכון בכל פעם שסיפור חדש יוצא.',
    //       textAlign: TextAlign.right,
    //       style:  TextStyle(fontSize: 18.0),
    //     )
    //   ],);
    // }
}