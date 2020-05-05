import 'package:daff_app/models/comment.dart';
import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/screens/author_screen.dart';
import 'package:daff_app/screens/new_comment_screen.dart';
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
                title: Text('${model.story.comments.length} תגובות על "${model.story.title}"'),
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
                  return model.story.comments.length == 0 ?
                  Center(child: Text('אין עדיין תגובות'))
                  : Column(children: <Widget>[
                    buildComment(model.story.comments.elementAt(index)),
                    buildDivider(5.0)
                  ],);

                }, 
                childCount: model.story.comments.length))
            ]),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewCommentScreen())),
              child: Icon(Icons.edit),
              backgroundColor: Colors.grey[300],
            ),
        );
  });}
  

  
  Widget buildComment(Comment comment){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorScreen(comment.author.name, comment.author.id))),
          child: Row(children: <Widget>[
            buildAvatarImage(comment.author.imageUrl, height: 45.0),
            SizedBox(width: 10.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Text(comment.author.name),
              Text(comment.createdAtFormatted,style: TextStyle(color: Colors.grey[500]),),
            ],)
          ],)
        ),
        SizedBox(height: 10.0,),
        Text(comment.content, style: TextStyle(fontSize: 20.0)),
      ],)
    );
  }
}