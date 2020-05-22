import 'package:daff_app/models/user.dart';
import 'package:daff_app/providers/auth_provider.dart';
import 'package:daff_app/screens/author_screen.dart';
import 'package:daff_app/screens/connect_screen.dart';
import 'package:daff_app/screens/stories_screen.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:daff_app/widgets/app_logo.dart';
import 'package:daff_app/widgets/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                // padding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 0.0),
                child: buildUserAvatar(context)//buildAppLogoLarge()
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
              Provider.of<AuthModel>(context).user.connected ? 
                ListTile(
                  dense: true,
                  title: Text('ניתוק'),
                  onTap: () {
                    Provider.of<AuthModel>(context, listen: false).logOut();
                    Navigator.pop(context);
                  },
                )
                : ListTile(
                  dense: true,
                  title: Text('כניסה'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectScreen()));
                  },
                ),
              ],)
          ),
          // Padding(
          //   padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
          //   child: GestureDetector(
          //     onTap: (){
          //       Navigator.pop(context);
          //       Navigator.push(context, MaterialPageRoute(builder: (context) => StoryScreen(544)));
          //     }, 
          //     child: buildLineLogo(), 
          //     // child: buildAppLogoLarge(),
          //   )
          // ),
          // buildLineLogo(),
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

Widget buildUserAvatar(BuildContext context){
  User user = Provider.of<AuthModel>(context).user;
  return user.connected ? 
    GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorScreen(user.author.name, user.id)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildAvatarImage(user.author.imageUrl),
          SizedBox(height: 5.0,),
          Text(user.author.name, style: TextStyle(fontSize: 18.0)),
        ],
      )
    )
   
  : Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: () {
            // Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectScreen()));
          },
          // icon: Icon(Icons.person_outline, size: 80)
          icon: FaIcon(FontAwesomeIcons.userCircle, color: Colors.grey[600]), iconSize: 50.0,
        ),
        // SizedBox(height: 5.0,),
        Text('כניסה', style: TextStyle(fontSize: 15.0)),
      ],
    );
  
  
}
