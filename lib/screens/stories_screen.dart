import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/stories_provider.dart';
import 'package:daff_app/widgets/drawer.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoriesScreen extends StatefulWidget {
  static const routeName = '/stories_screen';
  final String title;
  final String urlQuery;
  StoriesScreen(this.title, this.urlQuery);

  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen>{
  List<Story> stories = List<Story>();
  int currentPage = 1;

  bool homepage;
  @override
  void initState() { 
    print("loading stories page---------------");
    print('title:' + widget.title);
    print('query:' + widget.urlQuery);

    homepage = widget.title == 'בית';
    Provider.of<StoriesModel>(context, listen: false).fetchStoriesData(currentPage, widget.urlQuery)
      .then((List<Story> newStories) {
        newStories.forEach((Story s) => stories.add(s));
      });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      body: Consumer<StoriesModel>(
        builder: (BuildContext context,  StoriesModel model, Widget child) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: homepage,
              iconTheme: IconThemeData(color: Colors.grey),
              floating: true,
              pinned: false,
              snap: true,
              title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Theme.of(context).backgroundColor,
              actions: !homepage ? <Widget>[
                IconButton(icon:Icon(Icons.arrow_forward),
                  onPressed:() => Navigator.pop(context, false),
                )
              ]:null,

            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (!model.isLoading && index == model.storiesPerPage * currentPage - 15) {
                    print("------------------");
                    print("current index: $index");
                    print('current page: ' + model.currentPage.toString());
                    print('stories left to scroll: ${model.storiesPerPage * currentPage - index}');
                    print('total stories fetched: ${stories.length}');
                    currentPage ++;
                    model..fetchStoriesData(currentPage, widget.urlQuery).then((List<Story> newStories) => newStories.forEach((Story s) => stories.add(s)));
                  }  
                  return model.isLoading ? 
                    buildStoryPreviewLoaderWidget(context)
                  : Column(children: <Widget>[
                    // Text(index.toString()),
                    buildStoryPreviewWidget(stories[index], context)
                    ],);
                },
                childCount: model.isLoading ? 4 : stories.length
              )
            )
        ]
        );
      })
    );
  
  }
}