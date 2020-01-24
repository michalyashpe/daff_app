// import 'package:daff_app/authentication_model.dart';
import 'package:daff_app/models/stories_model.dart';
import 'package:daff_app/widgets/app_bar_widget.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  // final User user;
  // HomeScreen(this.user);
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWidget(),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // _buildWelcomeMessage(),
            _buildAllStories()
        ],)
      )
        
    );
    }

    Widget _buildAllStories(){
      List<Widget> storyPreviewList = List<Widget>(); 
      Provider.of<StoriesModel>(context).allStories.forEach((Story story){
      // widget.storiesModel.allStories.forEach((Story story){
        storyPreviewList.add(buildStoryPreviewWidget(story, context));
      });
      return Container(
        height: MediaQuery.of(context).size.height - 150.0,
        child: ListView(children: storyPreviewList)
      );
    }

    

    




    // Widget _buildWelcomeMessage(){
    //   String receive = user.gender == 'female' ? 'תקבלי': 'תקבל';
    //   return Column(
    //     children: <Widget>[
    //     Text('הי ${user.name}, התחברת בהצלחה :)',
    //       textAlign: TextAlign.right,
    //       style:  TextStyle(fontSize: 18.0,),
    //     ),
    //     Text('איזה כיף, מעכשיו $receive עדכון בכל פעם שסיפור חדש יוצא.',
    //       textAlign: TextAlign.right,
    //       style:  TextStyle(fontSize: 18.0),
    //     )
    //   ],);
    // }
}