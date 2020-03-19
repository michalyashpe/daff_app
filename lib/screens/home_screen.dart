// import 'package:daff_app/authentication_model.dart';
import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/stories_provider.dart';
import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/widgets/drawer.dart';
import 'package:daff_app/widgets/editor_pick_widget.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  @override
  void initState() { 
    // Provider.of<StoriesModel>(context, listen: false).initialize('home=true');
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
        body: Consumer<StoriesModel>(
          builder: (BuildContext context,  StoriesModel model, Widget child) {
            return model.isLoading ?
              Center(child: CircularProgressIndicator())
              : CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    floating: true,
                    pinned: false,
                    snap: true,
                    title: Text('בית'),
                    backgroundColor: Theme.of(context).backgroundColor,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index == model.storiesPerPage * model.currentPage - 15) {
                          print("------------------");
                          print("current index: $index");
                          print('current page: ' + model.currentPage.toString());
                          print('stories left to scroll: ${model.storiesPerPage * model.currentPage - index}');
                          print('total stories fetched: ${model.stories.length}');

                          // model.fetchNextPage('home=true');
                        }  
                        return Column(children: <Widget>[
                          Text(index.toString()),
                          buildStoryPreviewWidget(model.stories[index], context)
                          ],);
                      },
                      childCount: model.storiesCount
                    )
                  )
              ]
            );
          })
      );
    }
  
          



  Widget buildNumberedStoriesList(List<Story> stories){
    List<Widget> storiesList = List<Widget>();
    int index = 1;
    stories.forEach((Story story) {
      Widget row = Container(
        child: GestureDetector(
          onTap: () {
            Provider.of<StoryModel>(context, listen: false).initialize(story.id);
            // Navigator.of(context).pushNamed(StoryScreen.routeName,);
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



}