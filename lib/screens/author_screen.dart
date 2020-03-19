import 'package:daff_app/models/author.dart';
import 'package:daff_app/providers/author_screen_provider.dart';
import 'package:daff_app/widgets/all_rights_widget.dart';
import 'package:daff_app/widgets/app_bar_widget.dart';
import 'package:daff_app/widgets/avatar_widget.dart';
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

  @override
  void initState() {
    Provider.of<AuthorModel>(context, listen: false).initialize(widget.authorId);
    super.initState();
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthorModel>(
        builder: (BuildContext context,  AuthorModel model, Widget child) {
          return model.isLoading ? Center(child: CircularProgressIndicator() )
          : CustomScrollView(
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
            ),
            
            SliverList( 
              delegate: SliverChildListDelegate([
                SizedBox(height: 10.0,),
                _buildAuthorDetails(),
                SizedBox(height: 10.0,),
                _buildAuthorStories(),
                SizedBox(height: 10.0,),
                buildAllRights(),
                SizedBox(height: 10.0,),
              ],)
            )]
    );
        }));
  }

  Widget _buildAuthorDetails(){
    Author author = Provider.of<AuthorModel>(context).author;
    return Row(children: <Widget>[
      SizedBox(height: 30.0,),
      buildAvatarImage(author.stories.first),  //TODO: get this directly from author page json @dor
      SizedBox(width: 20.0),
      _buildAuthorStats(author)
     
    ],);
  }

  Widget _buildAuthorStats(Author author){
    return Row(children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(author.stories.length.toString(), style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
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
  Widget _buildAuthorStories(){
    Author author = Provider.of<AuthorModel>(context).author;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
      // Text('כל הסיפורים של ${author.name}:', ),
      SizedBox(height: 10.0,),
      Column(children: buildStoryPreviewList(author.stories, context, authorName: false))
    ],);


  }

}