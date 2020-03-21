 import 'package:daff_app/screens/stories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildDrawer(BuildContext context){
  return Drawer(
      child:  ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Row(
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
        ],
      ),
      
    );
}
