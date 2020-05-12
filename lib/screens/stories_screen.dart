import 'package:daff_app/providers/auth_provider.dart';
import 'package:daff_app/models/story.dart';
import 'package:daff_app/models/user.dart';
import 'package:daff_app/providers/stories_provider.dart';
import 'package:daff_app/screens/author_screen.dart';
import 'package:daff_app/screens/connect_screen.dart';
import 'package:daff_app/widgets/avatar_widget.dart';
import 'package:daff_app/widgets/drawer.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class StoriesScreen extends StatefulWidget {
  static const routeName = '/stories_screen';
  final String title;
  final String urlQuery;
  StoriesScreen(this.title, this.urlQuery);

  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  List<Story> stories = List<Story>();
  int currentPage = 1;

  bool homepage;
  @override
  void initState() {
    print("loading stories page---------------");
    print('title:' + widget.title);
    print('query:' + widget.urlQuery);

    homepage = widget.title == 'בית';
    Provider.of<StoriesModel>(context, listen: false)
        .fetchStoriesData(currentPage, widget.urlQuery)
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
            builder: (BuildContext context, StoriesModel model, Widget child) {
          return CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: homepage,
              iconTheme: IconThemeData(color: Colors.grey),
              floating: true,
              pinned: false,
              snap: true,
              title: Text(widget.title,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              leading: !homepage
                  ? IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context, false),
                    )
                  : null,
              actions: <Widget>[
                !Provider.of<AuthModel>(context).user.connected 
                ? IconButton(
                  onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectScreen())),
                  icon: FaIcon(FontAwesomeIcons.user
                ,)) 
                : _buildUserProfileButton(model.user),
              ],
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            MediaQuery.of(context).size.width < 768.0 ?
              buildMobileStoriesView(model)
              : buildTabletStoriesView(model)
          ]);
        }));
  }
  Widget _buildUserProfileButton(User user){
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorScreen(user.author.name, user.id))),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child:  buildAvatarImage(user.author.imageUrl)
      )
    );
  }

  Widget buildMobileStoriesView(StoriesModel model) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      if (!model.isLoading &&
          index == model.storiesPerPage * currentPage - 15) {
        print("------------------");
        print("current index: $index");
        print('current page: ' + model.currentPage.toString());
        print('stories left to scroll: ${model.storiesPerPage * currentPage - index}');
        print('total stories fetched: ${stories.length}');
        currentPage++;
        model
          ..fetchStoriesData(currentPage, widget.urlQuery).then(
              (List<Story> newStories) =>
                  newStories.forEach((Story s) => stories.add(s)));
      }
      return model.isLoading
          ? buildStoryPreviewLoaderWidget(context)
          : Column(children: <Widget>[
              SizedBox(
                height: 5.0,
              ),
              buildStoryPreviewWidget(stories[index], context),
            ]);
    }, childCount: model.isLoading ? 4 : stories.length));
  }

  Widget buildTabletStoriesView(StoriesModel model) {
    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          ///no.of items in the horizontal axis
          mainAxisSpacing: 5.0, //check if also relevant for mobile view
          childAspectRatio: 3.0,
          crossAxisCount: 2,
        ),
        delegate: SliverChildBuilderDelegate(//SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          if (!model.isLoading &&
              index == model.storiesPerPage * currentPage - 15) {
            print("------------------");
            print("current index: $index");
            print('current page: ' + model.currentPage.toString());
            print(
                'stories left to scroll: ${model.storiesPerPage * currentPage - index}');
            print('total stories fetched: ${stories.length}');
            currentPage++;
            model
              ..fetchStoriesData(currentPage, widget.urlQuery).then(
                  (List<Story> newStories) =>
                      newStories.forEach((Story s) => stories.add(s)));
          }
          return model.isLoading
              ? buildStoryPreviewLoaderWidget(context)
              : buildStoryPreviewWidget(stories[index], context);
        }, childCount: model.isLoading ? 4 : stories.length));
  }

  
}
