import 'package:daff_app/screens/connect_screen.dart';
import 'package:daff_app/screens/stories_screen.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:daff_app/widgets/app_logo.dart';
import 'package:flutter/material.dart';

Widget buildDrawer(BuildContext context){
  return Drawer(
      child: Column(
        // padding: EdgeInsets.zero,
        children: <Widget>[
          Expanded( 
            child: ListView(
              children: <Widget>[
              DrawerHeader(
                // padding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 0.0),
                child: buildAppLogoLarge()
              ),
              ListTile(
                dense: true,
                title: Text('הַסִּפּוּר שֶׁלָּנוּ'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StoryScreen(544)));
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

              // ListTile(
              //   dense: true,
              //   title: Text('כניסת משתמשים'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectScreen()));
              //   },
              // ),
              ListTile(
                dense: true,
                title: Text('תנאי השימוש והגנת הפרטיות'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StoryScreen(1959)));
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
