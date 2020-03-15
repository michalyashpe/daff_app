import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/stories_provider.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:provider/provider.dart';

class StoriesScreen extends StatefulWidget {
  static const routeName = '/stories_screen';
  final String title;
  final String urlQuery;
  StoriesScreen(this.title, this.urlQuery);

  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen>{

  @override
   Widget build(BuildContext context) {
    return Consumer<StoriesModel>(
      builder: (BuildContext context,  StoriesModel model, Widget child) {
        print(widget.urlQuery);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(widget.title), //_buildTitle(model.getTag, model.editorVotes),
            actions: <Widget>[
              IconButton(icon:Icon(Icons.arrow_forward),
                onPressed:() => Navigator.pop(context, false),
              )
            ],
            automaticallyImplyLeading: false,
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(right: 5.0, left: 5.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: model.isLoading ? Center(child: CircularProgressIndicator())
                  : PagewiseListView(
                    pageSize: model.storiesPerPage,
                    itemBuilder: (context, Story story, index) {
                      return buildStoryPreviewWidget(story, context);
                    },
                    pageFuture: (pageIndex) => model.fetchStoriesData(pageIndex + 1, widget.urlQuery)
                  )
                // buildAllRights(),

          )]
        )));
      });
  }


  
}