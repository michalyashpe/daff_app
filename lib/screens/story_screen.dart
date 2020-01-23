import 'package:daff_app/models/stories_model.dart';
import 'package:daff_app/widgets/app_bar_widget.dart';
import 'package:daff_app/widgets/editor_pick_widget.dart';
import 'package:daff_app/widgets/story_tags_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class StoryScreen extends StatelessWidget {

  final Story story;
  StoryScreen(this.story);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWidget(),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: ListView(
          children: <Widget>[
            _buildStoryTitle(),
            SizedBox(height: 15.0,),
            _buildProfileBox(),
            _buildContent()

           
        ],)
      )
        
    );
  }

  Widget _buildStoryTitle(){
    return Column(children: <Widget>[
      Row(children: <Widget>[
        Text(story.title, 
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
        ),
        SizedBox(width: 5.0,),
        buildEditerPickMedalWidget(story),
      ],),
      buildStoryTagsWidget(story.tags)
    ],);
  }

  Widget _buildProfileBox(){
    return Row(children: <Widget>[
      CircleAvatar(
        radius: 20.0,
        backgroundImage: NetworkImage(story.author.imageUrl)
      ),
      SizedBox(width: 10.0,), 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(story.author.name, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          Text(story.readingDurationString + " | " + story.dateFormatted, 
            style: TextStyle(fontSize: 12.0, color: Colors.grey[600]))
        ],
      )

    ],);
  }

  Widget _buildContent() {
    return Html(
      data: story.contents,
      defaultTextStyle: TextStyle(fontFamily: 'serif',),
      customTextAlign: (node) {
        return TextAlign.right;
      },
    );
  }
}