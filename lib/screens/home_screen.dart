// import 'package:daff_app/authentication_model.dart';
import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/stories_provider.dart';
import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/screens/stories_screen.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:daff_app/widgets/app_bar_widget.dart';
import 'package:daff_app/widgets/editor_pick_widget.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWidget(context, backButton: false),
      body: Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
        child: _buildHitsList(),

            // _buildEditorVotesList(),
            // _buildRecentStoriesList(),
            // buildAllRights()
            // _buildMostReadStoriesThisWeek(),
            // _buildMostCheeredStoriesThisMonth(),
            // _buildThisWeekStories(),
            // _buildAllStoriesLink(),
      )
        
    );
    }


  Widget _buildHitsList(){

      return PagewiseListView(
        pageSize: Provider.of<StoriesModel>(context).storiesPerPage,
        itemBuilder: (context, Story story, index) {
          return Column(children: <Widget>[
            Visibility(child: _buildTitle(), visible: index == 0),
            buildStoryPreviewWidget(story, context)

          ],);
        },
        pageFuture: (pageIndex) => Provider.of<StoriesModel>(context).fetchStoriesData(pageIndex + 1)
      );
      // return AnimationLimiter(
      //   child: ListView.builder(
      //     itemCount: Provider.of<HomeModel>(context).hits.length +1,
      //     itemBuilder: (BuildContext context, int index){
      //       if (index == 0)
      //         return _buildTitle();
      //         Story story =  Provider.of<HomeModel>(context).hits[index-1];
      //         return AnimationConfiguration.staggeredList(
      //           position: index,
      //           duration: const Duration(milliseconds: 375),
      //           child: SlideAnimation(
      //             verticalOffset: 50.0,
      //             child: FadeInAnimation(
      //               child: buildStoryPreviewWidget(story, context),
      //           )
      //         )
      //       );
      //     }
      //   )
      // );
  }
  Widget _buildTitle(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('השירים והסיפורים של הדף', style: TextStyle(fontSize: 22.0, )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('עשינו שקלול של החדשים והאהובים ביותר.'),
            Row(children: <Widget>[
              GestureDetector(
                onTap: () {
                  Provider.of<StoriesModel>(context, listen: false).initialize();
                  Navigator.of(context).pushNamed(StoriesScreen.routeName,);
                },
                child: Text('הצג בסדר כרונולוגי' , style: TextStyle(decoration: TextDecoration.underline)),
              ),
              Text(' | '),
              GestureDetector(
                onTap: () {
                  Provider.of<StoriesModel>(context, listen: false).initialize(editorVotes: true);
                  Navigator.of(context).pushNamed(StoriesScreen.routeName,);
                },
                child: Text('בחירות העורך', style: TextStyle(decoration: TextDecoration.underline)),
              ),
            ],),
            SizedBox(height: 10.0,)
            
        ],)


    ],);

  }
  



  // Widget _buildEditorVotesList(){
  //   List<Story> stories = Provider.of<HomeModel>(context).editorVotes;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Text('בחירות העורך האחרונות', style: h5),
  //       SizedBox(height: 10.0,),
  //       stories.isEmpty ? CircularProgressIndicator() : (buildNumberedStoriesList(stories.take(3).toList()))
  //   ],);
  // }

  // Widget _buildRecentStoriesList(){
  //       List<Story> stories = Provider.of<HomeModel>(context).recentStories;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Text('הסיפורים והשירים האחרונים', style: h5),
  //       SizedBox(height: 10.0,),
  //       stories.isEmpty ? CircularProgressIndicator() : (buildNumberedStoriesList(stories.take(3).toList()))
  //   ],);
  // }

  // Widget _buildMostReadStoriesThisWeek(){
  //   List<Story> stories = Provider.of<HomeModel>(context).mostReadStoriesThisWeek;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Text('הדפים הנקראים ביותר השבוע', style: h5),
  //       SizedBox(height: 10.0,),
  //       stories.isEmpty ? CircularProgressIndicator() : (buildNumberedStoriesList(stories.take(3).toList()))
  //   ],);
  // }

  // Widget _buildMostCheeredStoriesThisMonth(){
  //   List<Story> stories = Provider.of<HomeModel>(context).mostCheeredStoriesThisMonth;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Text('הדפים המפורגנים ביותר החודש', style: h5),
  //       SizedBox(height: 10.0,),
  //       stories.isEmpty ? CircularProgressIndicator() : (buildNumberedStoriesList(stories.take(3).toList()))
  //   ],);
  // }

  // Widget _buildThisWeekStories(){
  //   List<Story> stories = Provider.of<HomeModel>(context).thisWeekStories;
  //   int thisWeekAuthorsCount = Provider.of<HomeModel>(context).thisWeekAuthorsCount;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       thisWeekAuthorsCount == null || stories.isEmpty ? 
  //         Text('סיפורים ושירים מהשבוע האחרון', style: h5) 
  //         : Wrap(children: <Widget>[
  //             Text('${stories.length} סיפורים ושירים מהשבוע האחרון' , style: h5 ),
  //             Text('($thisWeekAuthorsCount כותבים)' , style: h5grey ),
  //         ],),
  //       stories.isEmpty ? CircularProgressIndicator() : 
  //       Container(
  //         // constraints: BoxConstraints(maxHeight: stories.length * 120.0),
  //         height: stories.length * 140.0 ,
  //         child: Column(children: buildStoryPreviewList(stories, context))
  //       )
  //       ],
  //   );
  // }


  Widget buildNumberedStoriesList(List<Story> stories){
    List<Widget> storiesList = List<Widget>();
    int index = 1;
    stories.forEach((Story story) {
      Widget row = Container(
        child: GestureDetector(
          onTap: () {
            Provider.of<StoryModel>(context, listen: false).initialize(story.id);
            Navigator.of(context).pushNamed(StoryScreen.routeName,);
          },
        child: Row(children: <Widget>[
          Text('$index. ${story.title.trimRight()}, ', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
          Text(story.author.name, style:  TextStyle(fontSize: 17.0)),
          buildEditerPickMedalWidget(story)
        ],)
      ,));
      storiesList.add(row);
      storiesList.add(SizedBox(height: 5.0,));
      index ++;
    });
    return Column(children: storiesList);
  }


  // Widget _buildAllStoriesLink() {
  //   return FlatButton(
  //     onPressed: () {
  //       Provider.of<StoriesModel>(context, listen: false).initialize();
  //       Navigator.of(context).pushNamed(StoriesScreen.routeName,);
  //     },
  //     child: Text('לכל הסיפורים והשירים...', style: TextStyle(fontSize: 25.0)),
  //   );
  // }
}