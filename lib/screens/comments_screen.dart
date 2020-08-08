import 'package:daff_app/models/comment.dart';
import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/story_provider.dart';
import 'package:daff_app/screens/author_screen.dart';
import 'package:daff_app/screens/new_comment_screen.dart';
import 'package:daff_app/screens/offer_connect_screen.dart';
import 'package:daff_app/widgets/avatar_widget.dart';
import 'package:daff_app/widgets/divider.dart';
import 'package:daff_app/widgets/loader.dart';
import 'package:daff_app/widgets/user_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final Story story;
  CommentsScreen(this.story);
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
        builder: (BuildContext context, StoryProvider model, Widget child) {
      return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(color: Colors.grey),
            floating: true,
            pinned: false,
            snap: true,
            backgroundColor: Theme.of(context).backgroundColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
            // actions: <Widget>[buildUserAvatar(context)],
          ),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index == 0)
              return model.isLoading
                  ? Center(child: buildLoader())
                  : _buildTitle();
            else
              return widget.story.comments.length == 0
                  ? Center(child: Text('אין עדיין תגובות'))
                  : Column(
                      children: <Widget>[
                        buildComment(
                            widget.story.comments.elementAt(index - 1)),
                        buildDivider(5.0)
                      ],
                    );
          }, childCount: widget.story.comments.length + 1))
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => model.user.connected
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewCommentScreen(widget.story)))
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OfferConnectScreen())),
          child: Icon(Icons.edit),
          backgroundColor: Colors.grey[300],
          // backgroundColor: Colors.amberAccent,
        ),
      );
    });
  }

  Widget _buildTitle() {
    String text = widget.story.comments.length == 0
        ? 'אין עדיין תגובות על '
        : '${widget.story.comments.length} ';
    text = text +
        'תגובות על "${widget.story.title}" של ${widget.story.author.name}';
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)));
  }

  Widget buildComment(Comment comment) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AuthorScreen(
                            comment.author.name, comment.author.id))),
                child: Row(
                  children: <Widget>[
                    buildAvatarImage(comment.author.imageUrl, height: 45.0),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(comment.author.name),
                        Text(
                          comment.niceCreatedAt,
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    )
                  ],
                )),
            SizedBox(
              height: 10.0,
            ),
            Text(comment.content, style: TextStyle(fontSize: 20.0)),
          ],
        ));
  }
}
