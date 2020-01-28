import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/stories_screen_provider.dart';
import 'package:daff_app/widgets/app_bar_widget.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoriesScreen extends StatelessWidget {
   Widget build(BuildContext context) {
    List<Story> stories = Provider.of<StoriesModel>(context).stories;

  // model.initialize();
    return Scaffold(
      appBar: buildAppBarWidget(),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Container(
          height: MediaQuery.of(context).size.height - 150.0,
          child: buildStoryPreviewList(stories, context)
        )
        )
    );
   }
}
  