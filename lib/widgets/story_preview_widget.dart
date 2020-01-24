import 'package:daff_app/models/stories_model.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:daff_app/widgets/story_tags_widget.dart';
import 'package:flutter/material.dart';

Widget buildStoryPreviewWidget(Story story, BuildContext context){
  return Container( 
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      color: Colors.grey[100],
    ),
    padding: EdgeInsets.all(5.0),
    child: Row(children: <Widget>[
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0))
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, new MaterialPageRoute(
            builder: (context) => StoryScreen(story)
          )
        );
          
        },
        child: Image.network( //story image
          story.imageUrl,
          width: 170.0,
        )
      )
    ),
    SizedBox(width: 10.0,),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(story.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)), 
          story.authorPick ? Image.asset('assets/medal.png', width: 20.0,) : Text(''), 
          Text(', '),
        ],),
        Text(story.author.name , style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
        Text(story.readingDurationString),
        buildStoryTagsWidget(story.tags),
        Text(story.dateFormatted)

    ],)

  ],));
}
