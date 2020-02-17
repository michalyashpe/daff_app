import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/author_screen_provider.dart';
import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/screens/author_screen.dart';
import 'package:daff_app/widgets/all_rights_widget.dart';
import 'package:daff_app/widgets/app_bar_widget.dart';
import 'package:daff_app/widgets/avatar_widget.dart';
import 'package:daff_app/widgets/editor_pick_widget.dart';
import 'package:daff_app/widgets/icon.dart';
import 'package:daff_app/widgets/story_tags_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
        child: Consumer<StoryModel>(
          builder: (BuildContext context,  StoryModel model, Widget child) {
            return model.isLoading ? Center(child: CircularProgressIndicator()) 
              : ListView(
                children: <Widget>[
                  _buildStoryTitle(model.story),
                  SizedBox(height: 10.0,),
                  _buildProfileBox(model.story),
                  SizedBox(height: 15.0,),
                  _buildContent(model.story),
                  SizedBox(height: 40.0,),
                  buildStoryTagsWidget(model.story.tags, context),
                  SizedBox(height: 40.0,),
                  _buildRatingBox(model.story),
                  // SizedBox(height: 20.0,),
                  // _buildMoreStories(context),
                  SizedBox(height: 10.0,),
                  buildAllRights(),
                  SizedBox(height: 10.0,),

                
              ],);
          }
      ))
        
    );
  }

  Widget _buildStoryTitle(Story story){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
        Text(story.title, 
          style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold)
        ),
        SizedBox(width: 5.0,),
        buildEditerPickMedalWidget(story, bigSize: true),
      ],),
    ],);
  }

  Widget _buildProfileBox(Story story){
    return Row(children: <Widget>[
      buildAvatarImage(story.author.imageUrl),
      SizedBox(width: 10.0,), 
      Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: Text(story.author.name, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
            onTap: (){
              Provider.of<AuthorModel>(context, listen: false).initialize(story.author.id);
              Navigator.of(context).pushNamed(AuthorScreen.routeName);
            }
          ),
          Text(story.readingDurationString + " | " + story.dateFormatted, 
            style: TextStyle(fontSize: 16.0, color: Colors.grey[600]))
        ],
      )

    ],);
  }



  Widget _buildContent(Story story) {
    return Html(
      data: story.contents,
      defaultTextStyle: TextStyle(fontFamily: 'serif'),
      customTextAlign: (node) {
        return TextAlign.right;
      },
      customTextStyle: ( node, TextStyle baseStyle) {
        //  if (node is dom.Element) {}
        return baseStyle.merge(GoogleFonts.alef())
          .merge(TextStyle(fontSize: 22.0, height: 1.3,));
      },
    );
  }

  Widget _buildRatingBox(Story story){
    return Column(children: <Widget>[
      Row(children: <Widget>[
        buildIcon('assets/icons/heart.svg'),
        SizedBox(width: 5.0,),
        Flexible(child: Text(story.cheersSummary, style: TextStyle(fontSize: 20.0), maxLines: 4,))
      ],),
      SizedBox(height: 10.0),
      Row(children: <Widget>[
        buildIcon('assets/icons/eye1.svg'),
        SizedBox(width: 5.0,),
        Text(story.readCountString, style: TextStyle(fontSize: 20.0))
      ],)

    ],);
  }

 
}

