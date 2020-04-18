import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/screens/author_screen.dart';
import 'package:daff_app/widgets/all_rights_widget.dart';
import 'package:daff_app/widgets/avatar_widget.dart';
import 'package:daff_app/widgets/editor_pick_widget.dart';
import 'package:daff_app/widgets/icon.dart';
import 'package:daff_app/widgets/player_widget.dart';
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
  bool showPlayer = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<StoryModel>(
      builder: (BuildContext context,  StoryModel model, Widget child) {
        return Scaffold(
          bottomSheet: !model.isLoading && model.story.hasAudio ? PlayerWidget(story: model.story) : Text(''),
          body:  CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(color: Colors.grey),
              floating: true,
              pinned: false,
              snap: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 3.0,),
                !model.isLoading ? buildEditerPickMedalWidget(model.story, size: 30.0) : Text('')
              ],),
              backgroundColor: Theme.of(context).backgroundColor,
              leading: IconButton(icon:Icon(Icons.arrow_back),
                onPressed:() => Navigator.pop(context, false),
              ),
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
         ) );
      }
    );
  }
      
      
      
     



  Widget _buildProfileBox(Story story, {bool loading = false}){
    return Row(children: <Widget>[
      loading ? 
        buildShimmeringCircle(40.0)
        : GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorScreen(story.author.name, story.author.id))),
          child: buildAvatarImage(story.author.imageUrl)
        ),
      SizedBox(width: 10.0,), 
      Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: loading ?
              buildShimmeringBox(height: 20.0, width: MediaQuery.of(context).size.width * 0.7) 
              : Text(story.author.name, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
            onTap: () => loading ? {} : Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorScreen(story.author.name, story.author.id)))
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
        loading ?
          buildShimmeringCircle(20.0) 
          : buildIcon('assets/icons/heart.svg'),
        SizedBox(width: 5.0,),
        loading ?
          buildShimmeringBox(width: 200.0, height: 40.0)
          : Flexible(child: Text(story.cheersSummary, style: TextStyle(fontSize: 20.0), maxLines: 4,))
      ],),
      SizedBox(height: 10.0),
      Row(children: <Widget>[
        loading ?
          buildShimmeringCircle(20.0)
        : buildIcon('assets/icons/eye1.svg'),
        SizedBox(width: 5.0,),
        loading ?
          buildShimmeringBox(width: 200.0, height: 40.0)
          : Text(story.readCountString, style: TextStyle(fontSize: 20.0))
      ],)

    ],);
  }

 
}
