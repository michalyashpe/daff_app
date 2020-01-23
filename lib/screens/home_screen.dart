import 'package:daff_app/authentication_model.dart';
import 'package:daff_app/models/stories_model.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:daff_app/widgets/app_bar_widget.dart';
import 'package:daff_app/widgets/story_tags_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  HomeScreen(this.user);
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
        print(story.title);
        storyPreviewList.add(_buildStoryPreview(story));
      });
      return Column(children: storyPreviewList);
    }

    Widget _buildStoryPreview(Story story){
      return Container( 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.grey[100],
        ),
        padding: EdgeInsets.all(5.0),
        child: Row(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0))
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(
                builder: (context) => StoryScreen(story)
              )
            );
              
            },
            child: Image.network( //story image
              story.imageUrl,
              width: 170.0,
            )
          )
        ),
        SizedBox(width: 10.0,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              Text(story.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)), 
              story.authorPick ? Image.asset('assets/medal.png', width: 20.0,) : Text(''), 
              Text(', '),
            ],),
            Text(story.author.name , style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
            Text(story.readingDurationString),
            buildStoryTagsWidget(story.tags),
            Text(story.dateFormatted)

        ],)

      ],));
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