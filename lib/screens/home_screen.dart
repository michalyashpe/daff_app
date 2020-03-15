// import 'package:daff_app/authentication_model.dart';
import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/stories_provider.dart';
import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/screens/stories_screen.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:daff_app/widgets/editor_pick_widget.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  
  // @override
  // void initState() {
  //   Provider.of<StoriesModel>(context, listen: false).initialize('hits=true');
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        // title: Text('בית: השירים והסיפורים של הדף', ),
        title: Text('בית'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: _buildHitsList(),
            // buildAllRights()
     
      )
        
    );
    }


  Widget _buildHitsList(){
    return Consumer<StoriesModel>(
      builder: (BuildContext context,  StoriesModel model, Widget child) {
        return model.isLoading 
          ? Center(child: CircularProgressIndicator()) 
          : PagewiseListView(
            pageSize: Provider.of<StoriesModel>(context).storiesPerPage,
            itemBuilder: (context, Story story, index) {
              return Column(children: <Widget>[
                // Visibility(child: _buildTitle(), visible: index == 0),
                buildStoryPreviewWidget(story, context)
              ],);
            },
            pageFuture: (pageIndex) => Provider.of<StoriesModel>(context).fetchStoriesData(pageIndex + 1, 'hits=true')
          );
   });
  }

  Widget buildNumberedStoriesList(List<Story> stories){
    List<Widget> storiesList = List<Widget>();
    int index = 1;
    stories.forEach((Story story) {
      Widget row = Container(
        child: GestureDetector(
          onTap: () {
            Provider.of<StoryModel>(context, listen: false).initialize(story.id);
            Navigator.of(context).pushNamed(StoryScreen.routeName,);
          },
        child: Row(children: <Widget>[
          Text('$index. ${story.title.trimRight()}, ', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
          Text(story.author.name, style:  TextStyle(fontSize: 17.0)),
          buildEditerPickMedalWidget(story)
        ],)
      ,));
      storiesList.add(row);
      storiesList.add(SizedBox(height: 5.0,));
      index ++;
    });
    return Column(children: storiesList);
  }



  Widget _buildDrawer(){
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
              },
            ),
          ],
        ),
        
      );
  }
}