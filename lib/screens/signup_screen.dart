import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:daff_app/widgets/app_logo.dart';
import 'package:daff_app/widgets/hyperlink.dart';
import 'package:daff_app/widgets/signup_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  final bool signUp;
  SignupScreen(this.signUp);
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>{
  bool signUp;
  @override
  void initState() { 
    signUp = widget.signUp;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
        child: Scaffold(
          body: Column(children: <Widget>[
            Expanded(
                flex: 3,
                child: buildAppLogo()
              ),
              Expanded(
                flex: 7,
                child: signUp ? _buildSignupButtons(context) : _buildLoginButtons(context)
              ),
              Expanded(
                flex: 2,
                child: _buildTermsAndServices(context),
              )
          ],
        ))
    );
  }

  Widget _buildSignupButtons(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.2),
      child: Column(
        children: <Widget>[
          buildSignUpButton('הרשמה דרך חשבון פייסבוק', FontAwesomeIcons.facebookSquare),
          SizedBox(height: 5.0,),
          buildSignUpButton('הרשמה דרך חשבון אפל', FontAwesomeIcons.apple),
          SizedBox(height: 5.0,),
          buildSignUpButton('הרשמה דרך חשבון אימייל', FontAwesomeIcons.at),
          SizedBox(height: 30.0,),
          Wrap(children: <Widget>[
        Text('יש לך כבר חשבון? '),
        buildHyperLink(
          text: 'כניסה מכאן', 
            onPressed: () {setState(() {
              signUp = false;
            });}
        )
      ],)
          
      ])
    );
  }




  

  Widget _buildLoginButtons(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.2),
      child: Column(
        children: <Widget>[
          buildSignUpButton('כניסה דרך חשבון פייסבוק', FontAwesomeIcons.facebookSquare),
          SizedBox(height: 5.0,),
          buildSignUpButton('כניסה דרך חשבון אפל', FontAwesomeIcons.apple),
          SizedBox(height: 5.0,),
          buildSignUpButton('כניסה דרך חשבון אימייל', FontAwesomeIcons.at),
          SizedBox(height: 30.0,),
          Wrap(children: <Widget>[
            Text('אין לך חשבון? '),
            buildHyperLink(
              text: 'יצירת חשבון חדש', 
              onPressed:  () {setState(() {
                signUp = true;
              });}
            )
          ],)
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

