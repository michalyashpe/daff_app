import 'package:daff_app/models/author.dart';
import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/author_provider.dart';
import 'package:daff_app/providers/user_provider.dart';
import 'package:daff_app/widgets/avatar_widget.dart';
import 'package:daff_app/widgets/shimmering_box.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorScreen extends StatefulWidget{
  final String name;
  final int authorId;
  AuthorScreen(this.name, this.authorId);
  _AuthorScreenState createState() => _AuthorScreenState();
}

class _AuthorScreenState extends State<AuthorScreen>{
  bool _authorIsUser  = false;
  @override
  void initState() {
    Provider.of<AuthorProvider>(context, listen: false).initialize(widget.authorId);
    if (widget.authorId == Provider.of<UserProvider>(context, listen: false).user.id)
      _authorIsUser = true;
    super.initState();
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthorProvider>(
        builder: (BuildContext context,  AuthorProvider model, Widget child) {
          return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(color: Colors.grey),
              floating: true,
              pinned: false,
              snap: true,
              title: Text(widget.name, style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Theme.of(context).backgroundColor,
              leading: IconButton(icon:Icon(Icons.arrow_back),
                onPressed:() => Navigator.pop(context, false),
              ),
              actions: <Widget>[
                _authorIsUser ? IconButton(
                  onPressed: () => print('coming soon'),
                  icon: Icon(Icons.edit)) : Text('')
              ],
            ),
            
            SliverList( 
              delegate: SliverChildListDelegate([
                SizedBox(height: 20.0,),
                _buildAuthorDetails(model.author, model.isLoading),//model.isLoading),
                SizedBox(height: 20.0,),
                model.isLoading ? 
                  Column(children: <Widget>[
                    buildStoryPreviewLoaderWidget(context),
                    buildStoryPreviewLoaderWidget(context),
                    buildStoryPreviewLoaderWidget(context)
                  ])
                  : _buildAuthorStories(model.author, model.isLoading),
                SizedBox(height: 10.0,),
              ],)
            )]
    );
        }));
  }

  Widget _buildAuthorDetails(Author author, bool loading){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        Row(children: <Widget>[
          loading ? buildShimmeringCircle(40.0) : buildAvatarImage(author.imageUrl),
          SizedBox(width: 20.0),
          loading ? _buildAuthorStastLoader() : _buildAuthorStats(author, loading),
        ],),
        SizedBox(height: 10.0,),
        Text( 
          !loading && author.aboutMe != null ? author.aboutMe : '', 
          maxLines: 5, 
          textAlign: TextAlign.right,
        )
      ],)
    );
  }

  Widget _buildAuthorStastLoader(){
    double width = 30.0;
    Widget stats =  Column(children: <Widget>[
      buildShimmeringBox(height: 20.0, width: width),
      SizedBox(height: 5.0,),
      buildShimmeringBox(height: 20.0, width: width)
    ],);
    return Row(children: <Widget>[
      stats, stats, stats
    ],);
  }

  Widget _buildAuthorStats(Author author , bool loading){
    return loading ? 
    Column(children: <Widget>[
      buildStoryPreviewLoaderWidget(context),
      buildStoryPreviewLoaderWidget(context),
      buildStoryPreviewLoaderWidget(context)
    ])
    : Row(children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(author.storiesCount.toString(), style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            Text('דפים')
          ],
        ),
        SizedBox(width: 20.0,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(author.cheersCount.toString(), style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            Text('פירגונים')
          ],
        ),

        SizedBox(width: 20.0,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(author.readsCount.toString(), style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            Text('קריאות')
          ],
        ),
    ],);
  }
  Widget _buildAuthorStories(Author author, bool loading){
    
    List<Widget> storyPreviewList = List<Widget>(); 
    author.stories.forEach((Story story){
      storyPreviewList.add(buildStoryPreviewWidget(story, context, authorName: false));
      storyPreviewList.add(SizedBox(height: 5.0,));
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
      Column(children: storyPreviewList)
    ],);


  }

}