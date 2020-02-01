import 'package:daff_app/models/author.dart';
import 'package:daff_app/providers/author_screen_provider.dart';
import 'package:daff_app/widgets/all_rights_widget.dart';
import 'package:daff_app/widgets/app_bar_widget.dart';
import 'package:daff_app/widgets/avatar_widget.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorScreen extends StatefulWidget{
  static const routeName = '/author_screen';
  _AuthorScreenState createState() => _AuthorScreenState();
}

class _AuthorScreenState extends State<AuthorScreen>{
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWidget(context),
      body: Provider.of<AuthorModel>(context).author == null ? CircularProgressIndicator() 
      : Padding(
        padding: EdgeInsets.only(right: 30.0, left: 30.0, top: 10.0),
        child: ListView(children: <Widget>[
        _buildAuthorDetails(),
        SizedBox(height: 30.0,),
        _buildAuthorStories(),
        // SizedBox(height: 10.0,),
        // buildAllRights()

      ],)
    ));
  }

  Widget _buildAuthorDetails(){
    Author author = Provider.of<AuthorModel>(context).author;
    return Row(children: <Widget>[
      buildAvatarImage(author.stories.first.author.imageUrl),  //TODO: get this directly from author page json @dor
      SizedBox(width: 15.0),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(author.name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          Text(author.activitySummary)
      ],)
    ],);
  }
  Widget _buildAuthorStories(){
    Author author = Provider.of<AuthorModel>(context).author;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
      Text('כל הסיפורים של ${author.name}:', ),
      SizedBox(height: 10.0,),
      Container(
        height: MediaQuery.of(context).size.height - 215.0,
        child: ListView(children: buildStoryPreviewList(author.stories, context))
      ),
    ],);


  }

}