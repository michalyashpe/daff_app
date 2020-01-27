import 'package:daff_app/models/story.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:daff_app/widgets/editor_pick_widget.dart';
import 'package:daff_app/widgets/story_tags_widget.dart';
import 'package:flutter/material.dart';


Widget buildStoryPreviewList(List<Story> stories, BuildContext context){
  List<Widget> storyPreviewList = List<Widget>(); 
  stories.forEach((Story story){
    storyPreviewList.add(buildStoryPreviewWidget(story, context));
    storyPreviewList.add(SizedBox(height: 15.0,));
  });
  return ListView(children: storyPreviewList);
}

Widget buildStoryPreviewWidget(Story story, BuildContext context){
  return Container( 
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      color: Colors.grey[100],
    ),
    padding: EdgeInsets.all(5.0),
    child: Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: _buildStoryImage(story, context)
        ),
        SizedBox(width: 10.0,),
        Expanded(
          flex: 3,
          child: _buildStoryInfo(story)
        )
        
  ],));
}

Widget _buildStoryImage(Story story, BuildContext context){
  double width = MediaQuery.of(context).size.width / 2;
  return  Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    ),
    // constraints: BoxConstraints( maxWidth: width, maxHeight: width),
    // width: width,
    // height: 200.0,
    child: GestureDetector(
      onTap: () {
        Navigator.push(context, new MaterialPageRoute(
          builder: (context) => StoryScreen(story)
        )
      );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Align(
          alignment: Alignment.bottomRight,
          // heightFactor: 1.0,
          widthFactor: 0.5,
          child: Image.network(
            story.imageUrl,
            // fit: BoxFit.fitWidth
          ),
        ),
      )
    )
  );
}

Widget _buildStoryInfo(Story story){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Text(story.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)), 
          buildEditerPickMedalWidget(story), 
          Text(" " + story.author.name , 
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)
          ),
        ],),
      Text(story.readingDurationString),
      buildStoryTagsWidget(story.tags),
      Text(story.dateFormatted)
  ],);
}
