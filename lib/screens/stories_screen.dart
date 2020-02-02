import 'package:daff_app/helpers/style.dart';
import 'package:daff_app/providers/stories_screen_provider.dart';
import 'package:daff_app/widgets/all_rights_widget.dart';
import 'package:daff_app/widgets/app_bar_widget.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:flutter/material.dart';
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
          appBar: buildAppBarWidget(context),
          body: Padding(
            padding: EdgeInsets.only(right: 30.0, left: 30.0, top: 10.0),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTitle(model.getTag), 
                SizedBox(height: 10.0,),
                Container(
                  child: model.isLoading ? Center(child: CircularProgressIndicator())
                  : Column(children: buildStoryPreviewList(model.stories, context, tagView: true))
                ),
                SizedBox(height: 10.0,),
                buildAllRights(),
                SizedBox(height: 10.0,),
              ],)

          )
        );
      });
  }

  Widget _buildTitle(String tag){
    return tag  != null && tag != '' ? 
      _buildTagTitle(tag) : Text('כל הסיפורים והשירים', style: h5bold) ;
  }  

  Widget _buildTagTitle(String tag){
    int count = Provider.of<StoriesModel>(context).storiesCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
      Row(children: <Widget>[
        GestureDetector(
          child: Text("הַכֹּל", style: h5bold),
          onTap: () => Provider.of<StoriesModel>(context, listen: false).initialize()
        ),
        Text(' >> '),
        Text(tag, style: h5bold)
      ],),
      count == null ? Text('') : Text(
        count.toString()
        + ' סיפורים ושירים (כרונולוגי)'
        ,style: TextStyle(fontSize: 20.0)
      )

    ],);

  }
}