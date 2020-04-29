import 'package:daff_app/helpers/style.dart';
import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/screens/offer_signup_screen.dart';
import 'package:daff_app/screens/stories_screen.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Widget buildDrawer(BuildContext context){
  return Drawer(
      child: Column(
        // padding: EdgeInsets.zero,
        children: <Widget>[
          Expanded( 
            child: ListView(
              children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/logo.svg',
                        width: 45.0,
                        semanticsLabel: 'Acme Logo'
                      ),
                      SizedBox(width: 10.0,),
                      Text(appName, style: TextStyle(fontSize: 35.0, fontFamily: GoogleFonts.alef().fontFamily)),
                    ]
                  ),
                      Text(appSlogen, style: TextStyle(fontSize: 20.0))

                ],)
              ),
              ListTile(
                dense: true,
                title: Text('הַסִּפּוּר שֶׁלָּנוּ'),
                onTap: () {
                  Navigator.pop(context);
                  Provider.of<StoryModel>(context, listen: false).initialize(544);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StoryScreen('הַסִּפּוּר שֶׁלָּנוּ')));
                },
              ),
              ListTile(
                dense: true,
                title: Text('עדכוני מערכת'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StoriesScreen('עדכוני מערכת', 'tag=עדכון')));
                },
              ),
              ListTile(
                dense: true,
                title: Text('בחירות העורך'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StoriesScreen('בחירות העורך', 'editor_votes=true')));
                },
              ),
              ListTile(
                dense: true,
                title: Text('אתגר התלונה'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StoriesScreen('אתגר התלונה', 'tag=אתגר התלונה')));
                },
              ),
              ListTile(
                dense: true,
                title: Text('כל הסיפורים בסדר כרונולוגי'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StoriesScreen('כל הסיפורים', '')));
                },
              ),
              ListTile(
                dense: true,
                title: Text('דפים מוקלטים'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StoriesScreen('דפים מוקלטים', 'with_audio=true')));
                },
              ),
              Divider(),

              ListTile(
                dense: true,
                title: Text('כניסת משתמשים'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OfferSignUpScreen()));
                },
              ),
              ListTile(
                dense: true,
                title: Text('תנאי השימוש והגנת הפרטיות'),
                onTap: () {
                  Navigator.pop(context);
                  Provider.of<StoryModel>(context, listen: false).initialize(1959);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StoryScreen('תנאי השימוש והגנת הפרטיות')));
                },
              ),
              ],)
          ),
          Container(
            // padding: EdgeInsets.only(right: 10.0),
            child: 
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                  Text(' כל הזכויות שמורות לכותבים ולכותבות ' , style: TextStyle(fontSize: 10.0, color: Colors.grey[600])),
                  Icon(Icons.copyright, size: 10.0, color: Colors.grey[600]),
                  Text( ' ' + DateTime.now().year.toString(), style: TextStyle(fontSize: 10.0, color: Colors.grey[600])),
                ],)
          ),
          SizedBox(height: 30.0),
        ],
      ),
    
      

      
    );
}
