import 'package:daff_app/helpers/style.dart';
import 'package:daff_app/screens/connect_screen.dart';
import 'package:daff_app/widgets/app_logo.dart';
import 'package:daff_app/widgets/hyperlink.dart';
import 'package:flutter/material.dart';

class OfferConnectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: buildAppLogo()
            ),
            Expanded(
              flex: 6,
              child: _buildReasons()
            ),
            Expanded(
              flex: 3,
              child: _buildButtons(context),
            )

              

      ],))
      
        
    );
  }

  Widget _buildButtons(BuildContext context){
    return Column(children: <Widget>[
      Row(
        children: <Widget>[ 
          Expanded(
            child: RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text('כניסה', style: TextStyle(fontSize: 20.0)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectScreen())),
            ))
          ]
      ),
      SizedBox(height: 20.0,),
      // buildHyperLink(
      //   text: 'יש לי כבר חשבון',
      //   onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectScreen(false))),
      // ),
      SizedBox(height: 10.0,),
      buildHyperLink(
        text: 'להמשיך לקרוא בלי להתחבר ',
        onPressed: () => Navigator.pop(context, false),
      ),
    ],);
  }


  Widget _buildReasons(){
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'לא תאמינו מה משתמשים רשומים עושים עם יישומון $appName!',
          // 'לא תאמינו מה אפשר לעשות ביישומון של $appName עם חשבון אישי:',
          // 'עם חשבון אישי אפשר לעשות הרבה יותר עם היישומון של $appName:',
          // 'לאחר שתתחברו לחשבון משלכם תוכלו לעשות הרבה יותר עם היישומון של $appName:',
          style: TextStyle(fontSize: 23.0),
        ),
        SizedBox(height: 20.0,),
        _buildReason('להגיב ולפרגן על דפים שאתם אוהבים', Icons.favorite),
        _buildReason('לעקוב אחרי הכותבים שאתם מחבבים', Icons.face),
        _buildReason('לקבל המלצות לקריאה על פי טעמכם האישי', Icons.star),
        _buildReason('לשמור דפים שאהבתם', Icons.bookmark),
    ]);
  }
  

  Widget _buildReason(String text, IconData iconData){
    return Padding(
      padding: EdgeInsets.only(right: 18.0),
      child: Column(children: <Widget>[
      Row(children: <Widget>[
        Icon(iconData, size: 18.0,),
        SizedBox(width: 10.0,),
        Text(text, style: TextStyle(fontSize: 16.0)),
      ],),
      SizedBox(height: 5.0,),
    ],));
    
  
  }

 

}