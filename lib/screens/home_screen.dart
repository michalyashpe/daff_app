// import 'package:daff_app/authentication_model.dart';
import 'package:daff_app/helpers/style.dart';
import 'package:daff_app/providers/home_screen_provider.dart';
import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/stories_screen_provider.dart';
import 'package:daff_app/screens/stories_screen.dart';
import 'package:daff_app/widgets/app_bar_widget.dart';
import 'package:daff_app/widgets/editor_pick_widget.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  // final User user;
  // HomeScreen(this.user);
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWidget(),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: ListView(
          children: <Widget>[
            _buildMostReadStoriesThisWeek(),
            SizedBox(height: 10.0,),
            _buildMostCheeredStoriesThisMonth(),
            SizedBox(height: 10.0,),
            _buildThisWeekStories(),
            SizedBox(height: 10.0,),
            _buildAllStoriesLink(),
        ],)
      )
        
    );
    }


  Widget _buildMostReadStoriesThisWeek(){
    List<Story> stories = Provider.of<HomeModel>(context).mostReadStoriesThisWeek;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('הדפים הנקראים ביותר השבוע', style: h5),
        stories.isEmpty ? CircularProgressIndicator() : (buildNumberedStoriesList(stories.take(3).toList()))
    ],);
  }

  Widget _buildMostCheeredStoriesThisMonth(){
    List<Story> stories = Provider.of<HomeModel>(context).mostCheeredStoriesThisMonth;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('הדפים המפורגנים ביותר החודש', style: h5),
        stories.isEmpty ? CircularProgressIndicator() : (buildNumberedStoriesList(stories.take(3).toList()))
    ],);
  }

  Widget _buildThisWeekStories(){
    List<Story> stories = Provider.of<HomeModel>(context).thisWeekStories;
    int thisWeekAuthorsCount = Provider.of<HomeModel>(context).thisWeekAuthorsCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        thisWeekAuthorsCount == null || stories.isEmpty ? 
          Text('סיפורים ושירים מהשבוע האחרון', style: h5) 
          : Wrap(children: <Widget>[
              Text('${stories.length} סיפורים ושירים מהשבוע האחרון' , style: h5 ),
              Text('($thisWeekAuthorsCount כותבים)' , style: h5grey ),
          ],),
        stories.isEmpty ? CircularProgressIndicator() : 
        Container(
          // constraints: BoxConstraints(maxHeight: stories.length * 120.0),
          height: stories.length * 120.0 + 20,
          child: Column(children: buildStoryPreviewList(stories, context))
        )
        ],
    );
  }


  Widget buildNumberedStoriesList(List<Story> stories){
    List<Widget> storiesList = List<Widget>();
    int index = 1;
    stories.forEach((Story story) {
      Widget row = Row(children: <Widget>[
        Text('$index. ${story.title}, ', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(story.author.name),
        buildEditerPickMedalWidget(story)
      ],);
      storiesList.add(row);
      storiesList.add(SizedBox(height: 3.0,));
      index ++;
    });
    return Column(children: storiesList);
  }


  Widget _buildAllStoriesLink() {
    return FlatButton(
      onPressed: () {
        Provider.of<StoriesModel>(context, listen: false).initialize();
        Navigator.push(context, new MaterialPageRoute(
          builder: (context) => StoriesScreen()
        ));
      },
      child: Text('לכל הסיפורים והשירים...', style: TextStyle(fontSize: 25.0)),
    );
  }
}