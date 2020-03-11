import 'package:daff_app/helpers/style.dart';
import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/stories_screen_provider.dart';
import 'package:daff_app/widgets/all_rights_widget.dart';
import 'package:daff_app/widgets/app_bar_widget.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:provider/provider.dart';

class StoriesScreen extends StatefulWidget {
  static const routeName = '/stories_screen';
  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen>{
   Widget build(BuildContext context) {
    return Consumer<StoriesModel>(
      builder: (BuildContext context,  StoriesModel model, Widget child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: _buildTitle(model.getTag, model.editorVotes),
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
                    pageFuture: (pageIndex) => model.fetchStoriesData(pageIndex + 1)
                  )
                // buildAllRights(),

          )]
        )));
      });
  }

  Widget _buildTitle(String tag, bool editorVotes){
    return tag != null && tag != '' ? 
      _buildTagTitle(tag) 
      : editorVotes ? Text('בחירות העורך', style: h5bold)
        : Text('כל הסיפורים והשירים', style: appBarTitle) ;
  }  

  Widget _buildTagTitle(String tag){
    int count = Provider.of<StoriesModel>(context).storiesCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(tag, style: h5bold),
      // Row(children: <Widget>[
      //   GestureDetector(
      //     child: Text("הַכֹּל", style: h5bold),
      //     onTap: () => Provider.of<StoriesModel>(context, listen: false).initialize()
      //   ),
      //   Text(' >> '),
      //   Text(tag, style: h5bold)
      // ],),
      // count == null ? Text('') : Text(
      //   count.toString()
      //   + ' סיפורים ושירים (כרונולוגי)'
      //   ,style: TextStyle(fontSize: 20.0)
      // )

    ],);

  }
}