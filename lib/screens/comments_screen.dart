import 'package:daff_app/models/comment.dart';
import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/widgets/avatar_widget.dart';
import 'package:daff_app/widgets/divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  CommentsScreen();
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen>{

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryModel>(
      builder: (BuildContext context,  StoryModel model, Widget child) {
        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text('תגובות על "${Provider.of<StoryModel>(context).story.title}"'),
                automaticallyImplyLeading: false,
                iconTheme: IconThemeData(color: Colors.grey),
                floating: true,
                pinned: false,
                snap: true,
                backgroundColor: Theme.of(context).backgroundColor,
                leading: IconButton(icon:Icon(Icons.arrow_back),
                  onPressed:() => Navigator.pop(context, false),
                ),
              ),
              
              SliverList(
                
                delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  print(index);
                  return Column(children: <Widget>[
                    buildComment(model.story.comments.elementAt(index)),
                    buildDivider(5.0)

                  ],);

                }, 
                childCount: model.isLoading ? 4 : model.story.comments.length))
            ])
        );
  });}

  Widget buildComment(Comment comment){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        Row(children: <Widget>[
          buildAvatarImage(comment.author.imageUrl, height: 40.0),
          SizedBox(width: 10.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            Text(comment.author.name),
            Text(comment.createdAtFormatted,style: TextStyle(color: Colors.grey[500]),),
          ],)
        ],),
        SizedBox(height: 10.0,),
        Text(comment.content),
      ],)
    );
  }
}