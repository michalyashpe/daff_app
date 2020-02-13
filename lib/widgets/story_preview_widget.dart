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
    // constraints: BoxConstraints(maxHeight: 250.0),
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
  return  Container(
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
    
  );
}

Widget _buildStoryInfo(Story story, BuildContext context, {bool tagView = false, bool authorName = true}){
  return Container( 
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Wrap(
            runSpacing: 4.0,
            spacing: 3.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Text(story.title +",", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,), ), 
              authorName ? Text(story.author.name, 
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, ),
              ) : Text(''),
              buildEditerPickMedalWidget(story), 
            ],
          )
        ),
        Text(story.readingDurationString),
        buildStoryTagsWidget(story.tags, context, tagView: tagView),
        Text(story.dateFormatted)
    ],
    )
  );
}
