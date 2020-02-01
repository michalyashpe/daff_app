import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:daff_app/widgets/editor_pick_widget.dart';
import 'package:daff_app/widgets/story_tags_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

double minStoryHeight = 100.0;

List<Widget> buildStoryPreviewList(List<Story> stories, BuildContext context, {bool tagView = false}){
  List<Widget> storyPreviewList = List<Widget>(); 
  stories.forEach((Story story){
    storyPreviewList.add(buildStoryPreviewWidget(story, context, tagView: tagView ));
    storyPreviewList.add(SizedBox(height: 15.0,));
  });
  return storyPreviewList;
}

Widget buildStoryPreviewWidget(Story story, BuildContext context, {bool tagView = false}){
  return Container( 
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      color: Colors.grey[100],
    ),
    constraints: BoxConstraints(minHeight: minStoryHeight + 10.0),
    padding: EdgeInsets.all(5.0),
    child: GestureDetector(
      onTap: () {
        Provider.of<StoryModel>(context, listen: false).initialize(story.id);
        Navigator.of(context).pushNamed(StoryScreen.routeName,);
      },
      child: Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: _buildStoryImage(story, context)
        ),
        SizedBox(width: 10.0,),
        Expanded(
          flex: 3,
          child: _buildStoryInfo(story, context, tagView: tagView)
        )
        
  ],)));
}

Widget _buildStoryImage(Story story, BuildContext context){
  double width = MediaQuery.of(context).size.width / 2;
  return  Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    ),
    constraints: BoxConstraints( maxWidth: width, maxHeight: width, minHeight:  minStoryHeight),
    width: width,
    child:  ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Align(
          alignment: Alignment.bottomRight,
          heightFactor: 0.5,
          widthFactor: 0.5,
          child: Image.network(
            story.imageUrl,
            fit: BoxFit.fitHeight
          ),
        ),
      )
    
  );
}

Widget _buildStoryInfo(Story story, BuildContext context, {bool tagView = false}){
  return Container( 
    constraints: BoxConstraints(minHeight: minStoryHeight),
    child: Column(
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
        buildStoryTagsWidget(story.tags, context, tagView: tagView),
        Text(story.dateFormatted)
    ],
    )
  );
}
