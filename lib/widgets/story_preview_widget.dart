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
          child: _buildStoryImage(story.imageUrl, context)
        ),
        SizedBox(width: 10.0,),
        Expanded(
          flex: 3,
          child: _buildStoryInfo(story, context, tagView: tagView, authorName: authorName)
        )
        
  ],))));
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
        Flexible(
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
        Flexible(child: Wrap(
          spacing: 0.0,
          children: <Widget>[
            Text(
              authorName ? '${story.readingDurationString} \u{00B7} ${story.author.name}' : story.readingDurationString,
              maxLines: 2, 
            ),
            SizedBox(width: 5.0,),
            story.hasAudio ? 
              Icon(Icons.volume_up, color: Colors.grey[700], size: 12.0,) 
              : Text('')
        ],)),
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

