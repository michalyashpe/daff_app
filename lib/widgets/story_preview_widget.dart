import 'package:daff_app/helpers/style.dart';
import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:daff_app/widgets/editor_pick_widget.dart';
import 'package:daff_app/widgets/shimmering_box.dart';
import 'package:daff_app/widgets/story_tags_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
        Navigator.push(context, MaterialPageRoute(builder: (context) => StoryScreen(story.title)));
      },
      child: IntrinsicHeight(child: Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: _buildStoryImage(story, context)
        ),
        SizedBox(width: 10.0,),
        Expanded(
          flex: 3,
          child: _buildStoryInfo(story, context, tagView: tagView, authorName: authorName)
        )
        
  ],))));
}

Widget _buildStoryImage(Story story, BuildContext context){
  return  Stack(children: <Widget>[
    Container(
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      image: DecorationImage(
        fit: BoxFit.cover,
        image: NetworkImage(
            story.imageUrl,
          ),)
    ),
    child: null
   
  ),
  Positioned(
    bottom: 5.0,
    left: 5.0,
    child: story.hasAudio ? 
      Icon(Icons.volume_up, color: Colors.white, size: 20.0,) 
      : Text(''),
  ),
  Positioned(
    top: 5.0,
    left: 0.0,
    child: story.isNew ? 
      Container(
        height: 20.0, width: 50.0, color: Colors.green[800], 
        child: Text('חדש', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold ,color: Colors.white), textAlign: TextAlign.center,) 
      ) : Text(''),
  )
  ],);
}

Widget _buildStoryInfo(Story story, BuildContext context, {bool tagView = false, bool authorName = true}){
  return Container( 
    child: Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: RichText(
            text: TextSpan(
              children: <InlineSpan> [
                TextSpan(
                  text: story.title.trim(), 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0 , color: Colors.black),
                ), 
                WidgetSpan(child: buildEditerPickMedalWidget(story), ),
              ]
            ))
        ),
        Text(
              authorName ? '${story.readingDurationString} \u{00B7} ${story.author.name}' : story.readingDurationString ,
              maxLines: 2, 
            ),
      
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
            child: buildShimmeringBox(height: 100.0)
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildShimmeringBox(height: 20.0),
                buildShimmeringBox(height: 20.0),
                buildShimmeringBox(height: 20.0, width: MediaQuery.of(context).size.width/4),
              ],
            )
          ),
        ],)
));
}

