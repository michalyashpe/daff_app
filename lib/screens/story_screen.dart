import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/widgets/all_rights_widget.dart';
import 'package:daff_app/widgets/app_bar_widget.dart';
import 'package:daff_app/widgets/editor_pick_widget.dart';
import 'package:daff_app/widgets/story_tags_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class StoryScreen extends StatefulWidget{
  static const routeName = '/story_screen';
  // final StoryModel storyModel = StoryModel();
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWidget(context),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Consumer<StoryModel>(
          builder: (BuildContext context,  StoryModel model, Widget child) {
            return model.isLoading ? CircularProgressIndicator() 
              : ListView(
                children: <Widget>[
                  _buildStoryTitle(model.story),
                  SizedBox(height: 15.0,),
                  _buildProfileBox(model.story),
                  SizedBox(height: 15.0,),
                  _buildContent(model.story),
                  SizedBox(height: 10.0,),
                  buildStoryTagsWidget(model.story.tags, context),
                  SizedBox(height: 10.0,),
                  _buildRatingBox(model.story),
                  // SizedBox(height: 20.0,),
                  // _buildMoreStories(context),
                  SizedBox(height: 10.0,),
                  buildAllRights()

                
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
      customTextStyle: ( node, TextStyle baseStyle) {
        //  if (node is dom.Element) {}
        return baseStyle.merge(GoogleFonts.alef())
          .merge(TextStyle(fontSize: 18.0, height: 1.2));
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

 
}