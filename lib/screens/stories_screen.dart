import 'package:daff_app/helpers/style.dart';
import 'package:daff_app/providers/stories_screen_provider.dart';
import 'package:daff_app/widgets/app_bar_widget.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoriesScreen extends StatefulWidget {
  final String tag;
  StoriesScreen({this.tag = ''});
  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen>{
   Widget build(BuildContext context) {
    return Consumer<StoriesModel>(
      builder: (BuildContext context,  StoriesModel model, Widget child) {
        return Scaffold(
          appBar: buildAppBarWidget(),
          body: Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTagTitle(), 
                SizedBox(height: 10.0,),
                Container(
                  height: MediaQuery.of(context).size.height - 200.0,
                  child: model.isLoading ? Center(child: CircularProgressIndicator())
                  : ListView(
                    children: buildStoryPreviewList(model.stories, context)
                    )
                )
              ],)

          )
        );
      });
  }

  Widget _buildTagTitle(){
    return widget.tag  != null && widget.tag != '' ? 
      Text('הכל >> ${widget.tag}' , style: h1) 
      : Text('כל הסיפורים והשירים', style: h1) ;
  }  
}