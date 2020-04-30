import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/screens/email_connect_screen.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:daff_app/widgets/app_logo.dart';
import 'package:daff_app/widgets/hyperlink.dart';
import 'package:daff_app/widgets/connect_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ConnectScreen extends StatefulWidget {
  ConnectScreen();
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen>{

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
        child: Scaffold(
            appBar: AppBar(
        title: Text('כניסת משתמשים'),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: _buildConnectButtons(context)
              ),
              Expanded(
                flex: 2,
                child: _buildTermsAndServices(context),
              )
          ],
        ))
    );
  }

  Widget _buildConnectButtons(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 30.0,),
          buildAppLogoLarge(),
          SizedBox(height: 30.0,),
          buildConnectUpButton(
            text: 'כניסה עם חשבון אימייל', 
            iconData: FontAwesomeIcons.at,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EmailConnectScreen())),
            ),
          SizedBox(height: 20.0,),
          buildConnectUpButton(
            text: 'כניסה עם חשבון פייסבוק', 
            iconData: FontAwesomeIcons.facebookSquare,
            onPressed: (){}
            ),
          SizedBox(height: 20.0,),
          buildConnectUpButton(// TODO: only for iphone users
            text: 'כניסה עם חשבון אפל', 
            iconData: FontAwesomeIcons.apple,
            onPressed: (){}
            ),
          SizedBox(height: 20.0,),
          Text('מבטיחים לא לשלוח ספאם, רק סיפורים ושירים.', style: TextStyle(fontSize: 18.0)),
          // SizedBox(height: 30.0,),
          // Wrap(children: <Widget>[
          //   Text('יש לך כבר חשבון? '),
          //   buildHyperLink(
          //     text: 'כניסה מכאן', 
          //       onPressed: () {setState(() {
          //         signUp = false;
                // });}
            // )
          // ],)
          
      ])
    );
  }




  

  Widget _buildTermsAndServices(BuildContext context){
    return Column(
      children: <Widget>[
        Wrap(children: <Widget>[
          Text('הרשמה מהווה הסכמה ל'),
          buildHyperLink(
            text: 'תנאי השימוש', 
            onPressed: () {
              Provider.of<StoryModel>(context, listen: false).initialize(1959);
              Navigator.push(context, MaterialPageRoute(builder: (context) => StoryScreen('תנאי השימוש והגנת הפרטיות')));
            })
        ],),
        SizedBox(height: 15.0,),
        buildHyperLink(
          text: 'להמשיך לקרוא בלי להתחבר ',
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        )
    ],)
   ;
  }

  

}

