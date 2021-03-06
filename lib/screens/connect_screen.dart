import 'package:daff_app/providers/auth_provider.dart';
import 'package:daff_app/screens/email_connect_screen.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:daff_app/screens/user_profile_screen.dart';
import 'package:daff_app/widgets/app_logo.dart';
import 'package:daff_app/widgets/hyperlink.dart';
import 'package:daff_app/widgets/connect_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ConnectScreen extends StatefulWidget {
  ConnectScreen();
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  @override
  void initState() {
    if (Provider.of<AuthModel>(context, listen: false).user.connected) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserProfileScreen()));
      });
    }
    super.initState();
  }

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
                Expanded(flex: 6, child: _buildConnectButtons(context)),
                Expanded(
                  flex: 2,
                  child: _buildTermsAndServices(context),
                )
              ],
            )));
  }

  Widget _buildConnectButtons(BuildContext context) {
    return Consumer<AuthModel>(
        builder: (BuildContext context, AuthModel model, Widget child) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                buildAppLogoLarge(),
                SizedBox(
                  height: 30.0,
                ),
                buildConnectUpButton(
                  text: 'כניסה עם חשבון אימייל',
                  iconData: FontAwesomeIcons.at,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmailConnectScreen())),
                ),
                SizedBox(
                  height: 20.0,
                ),
                buildConnectUpButton(
                    loading: model.isLoadingFacebook,
                    text: 'כניסה עם חשבון פייסבוק',
                    iconData: FontAwesomeIcons.facebookSquare,
                    onPressed: () async {
                      bool loggedIn = await model.facebookLogin();
                      if (!model.isLoading && loggedIn) {
                        if (model.fromOfferScreen) {
                          for (var i = 0; i < 2; i++) {
                            if (Navigator.of(context).canPop())
                              Navigator.of(context).pop();
                          }
                          model.fromOfferScreen = false;
                        } else
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                      }
                    }),
                SizedBox(
                  height: 20.0,
                ),
                buildConnectUpButton(
                    // TODO: only for iphone users
                    text: 'כניסה עם חשבון אפל',
                    iconData: FontAwesomeIcons.apple,
                    onPressed: () {}),
                SizedBox(
                  height: 20.0,
                ),
                Text('מבטיחים לא לשלוח ספאם, רק סיפורים ושירים.',
                    style: TextStyle(fontSize: 18.0)),
              ]));
    });
  }

  Widget _buildTermsAndServices(BuildContext context) {
    return Column(
      children: <Widget>[
        Wrap(
          children: <Widget>[
            Text('הרשמה מהווה הסכמה ל'),
            buildHyperLink(
                text: 'תנאי השימוש',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoryScreen(1959)));
                })
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        buildHyperLink(
          text: 'להמשיך לקרוא בלי להתחבר ',
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        )
      ],
    );
  }
}
