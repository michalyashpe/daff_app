import 'package:daff_app/helpers/style.dart';
import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:daff_app/widgets/editor_pick_widget.dart';
import 'package:daff_app/widgets/story_tags_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


List<Widget> buildStoryPreviewList(List<Story> stories, BuildContext context, {bool tagView = false, authorName = true}){
  List<Widget> storyPreviewList = List<Widget>(); 
  stories.forEach((Story story){
    storyPreviewList.add(buildStoryPreviewWidget(story, context, tagView: tagView, authorName: authorName ));
    storyPreviewList.add(SizedBox(height: 15.0,));
  });
  return storyPreviewList;
}

Widget buildStoryPreviewWidget(Story story, BuildContext context, {bool tagView = false, bool authorName = true}){
  return Container( 
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      color: Colors.grey[100],
    ),
    padding: EdgeInsets.all(5.0),
    child: GestureDetector(
      onTap: () {
        Provider.of<StoryModel>(context, listen: false).initialize(story.id);
        Navigator.of(context).pushNamed(StoryScreen.routeName,);
      },
      child: IntrinsicHeight(child: Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: _buildStoryImage(story.imageUrl, context)
        ),
        SizedBox(width: 10.0,),
        Expanded(
          flex: 3,
          child: _buildStoryInfo(story, context, tagView: tagView, authorName: authorName)
        )
        
  ],))));
}

Widget buildStoryPreviewLoaderWidget(BuildContext context){
  return Container( 
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      color: Colors.grey[100],
    ),
    padding: EdgeInsets.all(5.0),
    child: IntrinsicHeight(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: _buildStoryImage('story', context)
          ),
          SizedBox(width: 10.0,),
          Expanded(
            flex: 3,
            child: Text('story info')//_buildStoryInfo(story, context, tagView: tagView, authorName: authorName)
          )
        ],)
));
}
Widget _buildStoryImage(String imageUrl, BuildContext context){
  return  Container(
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      image: DecorationImage(
        fit: BoxFit.cover,
        image: NetworkImage(
            imageUrl,
          ),)
    ),
    child: null
    
  );
}

Widget _buildStoryInfo(Story story, BuildContext context, {bool tagView = false, bool authorName = true}){
  return Container( 
    child: Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: RichText(
            text: TextSpan(
              children: <InlineSpan> [
                TextSpan(
                  text: story.title.trim() + (!story.editorPick ? ', ':''), 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0 , color: Colors.black),
                ), 
                WidgetSpan(child: buildEditerPickMedalWidget(story), ),
                authorName 
                  ? TextSpan(text: story.author.name, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
              )   : TextSpan(text: ''),
              ]
            ))
        ),
        // SizedBox(height: storyPreviewLineHeight/2.0),
        Text(story.readingDurationString),
        story.tags.length > 0 ? Column(children: <Widget>[
          SizedBox(height: storyPreviewLineHeight),
          buildStoryTagsWidget(story.tags, context, tagView: tagView),
        ],): Text(''),
        SizedBox(height: storyPreviewLineHeight),
        Text(story.dateFormatted),
        SizedBox(height: storyPreviewLineHeight),
    ],
    )
  );
}
