import 'package:daff_app/providers/story_screen_provider.dart';
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
            child: ListView(children: <Widget>[
              DrawerHeader(
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
                      Text('הַדַּף', style: TextStyle(fontSize: 35.0, fontFamily: GoogleFonts.alef().fontFamily)),
                    ]
                  ),
                      Text('במה ליצירה עצמאית', style: TextStyle(fontSize: 20.0))

                ],)
              ),
              ListTile(
                title: Text('בחירות העורך'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StoriesScreen('בחירות העורך', 'editor_votes=true')));
                },
              ),
              ListTile(
                title: Text('אתגר התלונה'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StoriesScreen('אתגר התלונה', 'tag=אתגר התלונה')));
                },
              ),
              ListTile(
                title: Text('כל הסיפורים בסדר כרונולוגי'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StoriesScreen('כל הסיפורים', '')));
                },
              ),
              ListTile(
                title: Text('סיפורים מוקלטים'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StoriesScreen('סיפורים מוקלטים', 'with_audio=true')));
                },
              ),
              Divider(),
              ListTile(
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
            // alignment: Alignment.bottomCenter,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(' כל הזכויות שמורות לכותבים ולכותבות ' , style: TextStyle(color: Colors.grey[600])),
                Icon(Icons.copyright, size: 15.0, color: Colors.grey[600]),
                Text( ' ' + DateTime.now().year.toString(), style: TextStyle(color: Colors.grey[600])),
              ],)
            ),
          SizedBox(height: 10.0),
        ],
      ),
    
      

      
    );
}
