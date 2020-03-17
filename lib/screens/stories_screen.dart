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
  bool homepage;
  @override
  void initState() { 
    print("loading stories page---------------");
    print('title:' + widget.title);
    print('query:' + widget.urlQuery);

    homepage = widget.title == 'בית';
    print('homepage: $homepage');

    Provider.of<StoriesModel>(context, listen: false).initialize(widget.urlQuery);
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
              floating: true,
              pinned: false,
              snap: true,
              title: Text(widget.title),
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
                  if (!model.isLoading && index == model.storiesPerPage * model.currentPage - 15) {
                    print("------------------");
                    print("current index: $index");
                    print('current page: ' + model.currentPage.toString());
                    print('stories left to scroll: ${model.storiesPerPage * model.currentPage - index}');
                    print('total stories fetched: ${model.stories.length}');

                    model.fetchNextPage(widget.urlQuery);
                  }  
                  return model.isLoading 
                  ? buildStoryPreviewLoaderWidget(context)
                  : Column(children: <Widget>[
                    // Text(index.toString()),
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
}