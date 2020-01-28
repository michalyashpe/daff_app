import 'package:daff_app/models/story.dart';
import 'package:daff_app/models/story_screen_model.dart';
import 'package:daff_app/widgets/app_bar_widget.dart';
import 'package:daff_app/widgets/editor_pick_widget.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:daff_app/widgets/story_tags_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class StoryScreen extends StatefulWidget{
  // final StoryModel storyModel = StoryModel();
  final int storyId;
  StoryScreen(this.storyId);
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>{


  void initState() {
    // widget.storyModel.initialize(widget.storyId);
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWidget(),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Consumer<StoryModel>(
          builder: (BuildContext context,  StoryModel model, Widget child) {
            if (!model.storyLoaded(widget.storyId))  model.initialize(widget.storyId);
            return !model.storyLoaded(widget.storyId) ? CircularProgressIndicator() 
              : ListView(
                children: <Widget>[
                  _buildStoryTitle(model.story),
                  SizedBox(height: 15.0,),
                  _buildProfileBox(model.story),
                  SizedBox(height: 15.0,),
                  _buildContent(model.story),
                  SizedBox(height: 10.0,),
                  buildStoryTagsWidget(model.story.tags),
                  SizedBox(height: 10.0,),
                  _buildRatingBox(model.story),
                  // SizedBox(height: 20.0,),
                  // _buildMoreStories(context),
                  // SizedBox(height: 10.0,),
                  // _buildAllRights()

                
              ],);
          }
      ))
        
    );
  }

  Widget _buildStoryTitle(Story story){
    return Column(children: <Widget>[
      Row(children: <Widget>[
        Text(story.title, 
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
        ),
        SizedBox(width: 5.0,),
        buildEditerPickMedalWidget(story),
      ],),
    ],);
  }

  Widget _buildProfileBox(Story story){
    return Row(children: <Widget>[
      ClipOval(
        // radius: 20.0,
        child: _buildAvatarImage(story.author.imageUrl)
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

  Widget _buildAvatarImage(String imageUrl){
    return Container(
      height: 50.0,
      child: imageUrl.split(".").last == 'svg' ? 
        SvgPicture.network(imageUrl) 
        : Image.network(imageUrl)
    );
  }

  Widget _buildContent(Story story) {
    return Html(
      data: story.contents,
      defaultTextStyle: TextStyle(fontFamily: 'serif',),
      customTextAlign: (node) {
        return TextAlign.right;
      },
    );
  }

  Widget _buildRatingBox(Story story){
    return Column(children: <Widget>[
      Row(children: <Widget>[
        Icon(Icons.favorite),
        SizedBox(width: 5.0,),
        Text(story.firgunSummary)
      ],),
      Row(children: <Widget>[
        Icon(Icons.remove_red_eye),
        SizedBox(width: 5.0,),
        Text(story.readCountString)
      ],)

    ],);
  }

  Widget _buildMoreStories(BuildContext context, Story story){
    List<Widget> moreStoriesPreviewList = List<Widget>();
    story.moreStories.forEach((Story s){
      moreStoriesPreviewList.add(buildStoryPreviewWidget(s, context));
    });
    return Column(children: <Widget>[
      // Text('עוד דפים:'),
      Column(children: moreStoriesPreviewList)

    ],);
  }

  Widget _buildAllRights(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('כל הזכויות שמורות למחבר כפרה עליו '),
        Icon(Icons.copyright, size: 15.0),
        Text( ' ' + DateTime.now().year.toString())
    ],);
  }
}