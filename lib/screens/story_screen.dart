import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/author_screen_provider.dart';
import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/screens/author_screen.dart';
import 'package:daff_app/widgets/all_rights_widget.dart';
import 'package:daff_app/widgets/avatar_widget.dart';
import 'package:daff_app/widgets/editor_pick_widget.dart';
import 'package:daff_app/widgets/icon.dart';
import 'package:daff_app/widgets/shimmering_box.dart';
import 'package:daff_app/widgets/story_tags_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class StoryScreen extends StatefulWidget{
  static const routeName = '/story_screen';
  final String title;
  StoryScreen(this.title);
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>{

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Consumer<StoryModel>(
        builder: (BuildContext context,  StoryModel model, Widget child) {
          return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(color: Colors.grey),
              floating: true,
              pinned: false,
              snap: true,
              title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Theme.of(context).backgroundColor,
              actions: <Widget>[
                IconButton(icon:Icon(Icons.arrow_forward),
                  onPressed:() => Navigator.pop(context, false),
                ) 
              ],
            ),
            
            SliverList(
              delegate: SliverChildListDelegate([
                // _buildStoryTitle(model.story),
                SizedBox(height: 10.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: _buildProfileBox(model.story, loading: model.isLoading)
                ),
                SizedBox(height: 15.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: _buildContent(model.story, loading: model.isLoading),
                ),
                
                SizedBox(height: 40.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: model.isLoading 
                    ? buildStoryTagsWidgetLoader()
                    : buildStoryTagsWidget(model.story.tags, context),
                ),
                
                SizedBox(height: 40.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: _buildRatingBox(model.story, loading: model.isLoading),
                ),
                
                // SizedBox(height: 20.0,),
                // _buildMoreStories(context),
                SizedBox(height: 10.0,),
                // buildAllRights(),
                // SizedBox(height: 10.0,),
              ])
          )]
        );
      }
    ));
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

  Widget _buildProfileBox(Story story, {bool loading = false}){
    return Row(children: <Widget>[
      buildAvatarImage(story.author.imageUrl, loading: loading),
      SizedBox(width: 10.0,), 
      Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: loading 
              ? buildShimmeringBox(height: 20.0, width: MediaQuery.of(context).size.width * 0.7) 
              : Text(story.author.name, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
            onTap: (){
              Provider.of<AuthorModel>(context, listen: false).initialize(story.author.id);
              Navigator.of(context).pushNamed(AuthorScreen.routeName);
            }
          ),
          loading 
            ? buildShimmeringBox(height: 20.0, width: MediaQuery.of(context).size.width * 0.4) 
            : Text(story.readingDurationString + " | " + story.dateFormatted, 
              style: TextStyle(fontSize: 16.0, color: Colors.grey[600]))
        ],
      )

    ],);
  }



  Widget _buildContent(Story story ,{bool loading = false}) {
    return loading 
    ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildShimmeringParagraph(context),
        SizedBox(height: 20.0,),
        buildShimmeringParagraph(context),
        SizedBox(height: 20.0,),

    ],)
    : Html(
      data: story.contents,
      defaultTextStyle: TextStyle(fontFamily: 'serif'),
      customTextAlign: (node) {
        return TextAlign.right;
      },
      customTextStyle: ( node, TextStyle baseStyle) {
        return baseStyle.merge(GoogleFonts.alef())
          .merge(TextStyle(fontSize: 22.0, height: 1.3,));
      },
    );
  }

  Widget _buildRatingBox(Story story, {bool loading = false}){
    return Column(children: <Widget>[
      Row(children: <Widget>[
        buildIcon('assets/icons/heart.svg'),
        SizedBox(width: 5.0,),
        loading 
          ? buildShimmeringBox(width: 200.0, height: 40.0)
          : Flexible(child: Text(story.cheersSummary, style: TextStyle(fontSize: 20.0), maxLines: 4,))
      ],),
      SizedBox(height: 10.0),
      Row(children: <Widget>[
        buildIcon('assets/icons/eye1.svg'),
        SizedBox(width: 5.0,),
        loading 
          ? buildShimmeringBox(width: 200.0, height: 40.0)
          : Text(story.readCountString, style: TextStyle(fontSize: 20.0))
      ],)

    ],);
  }

 
}

