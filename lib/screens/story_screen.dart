import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/screens/author_screen.dart';
import 'package:daff_app/widgets/avatar_widget.dart';
import 'package:daff_app/widgets/editor_pick_widget.dart';
import 'package:daff_app/widgets/player_widget.dart';
import 'package:daff_app/widgets/shimmering_box.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:daff_app/widgets/story_tags_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:html/dom.dart' as dom;

class StoryScreen extends StatefulWidget{
  static const routeName = '/story_screen';
  final String title;
  StoryScreen(this.title);
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>{
  double padding = 10.0;
  @override
  Widget build(BuildContext context) {
    return Consumer<StoryModel>(
      builder: (BuildContext context,  StoryModel model, Widget child) {
        return Scaffold(
          bottomSheet: !model.isLoading && model.story.hasAudio ? PlayerWidget(story: model.story) : Text(''),
          body:  CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(color: Colors.grey),
              floating: true,
              pinned: false,
              snap: true,
              backgroundColor: Theme.of(context).backgroundColor,
              leading: IconButton(icon:Icon(Icons.arrow_back),
                onPressed:() => Navigator.pop(context, false),
              ),
              actions: <Widget>[
                _storyOptionsMenu(model.story)
                // IconButton(ic/on: Icon(Icons.donut_small))
              ],
            ),
            
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 15.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: _buildTitle(model.story, loading: model.isLoading)
                ),
                SizedBox(height: 20.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: _buildMiniProfileBox(model.story, loading: model.isLoading)
                ),
                SizedBox(height: 15.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: _buildContent(model.story, loading: model.isLoading),
                ),
                SizedBox(height: 40.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: model.isLoading 
                    ? buildStoryTagsWidgetLoader()
                    : buildStoryTagsWidget(model.story.tags, context,fontSize: 18.0),
                ),
                SizedBox(height: 10.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: _buildRatingBox(model.story, loading: model.isLoading),
                ),
                // _buildMoreStories(context),
                SizedBox(height: 10.0,),
                _buildDivider(5.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: _buildProfileBox(model.story, loading: model.isLoading)
                ),
                _buildDivider(15.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: _buildRecommendedStories( model.story, loading: model.isLoading)
                ),
                !model.isLoading && model.story.hasAudio ?
                  SizedBox(height: 70.0) : Text(''),
              ])
          )]
         ) );
      }
    );
  }
  
  Widget _buildDivider(double height) {
    return Container(color: Colors.grey[200], height: height,);
  }
  Widget _buildRecommendedStories(Story story, {bool loading = false}){
    return loading ? buildShimmeringBox(height: 50.0)
    : Container( 
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        Text('מומלצים בשבילך:',
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 20.0, color: Colors.grey[700]),
        ),
        SizedBox(height: 5.0,),
        Column(children: story.recommended.map((Story s) => buildStoryPreviewWidget(s, context)).toList(),),
        // SizedBox(height: 15.0,),
    ],)
    );
  }








  Widget _buildTitle(Story story, {bool loading = false}) {
    return loading ?
      buildShimmeringBox(height: 40.0, width: MediaQuery.of(context).size.width * 0.7) 
      : Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
        Text(
          story.title,
          maxLines: 3,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0), 
          // overflow: TextOverflow.fade,
        ),
        SizedBox(width: 3.0,),
        buildEditerPickMedalWidget(story, size: 30.0),
      ],);
  }


 
  Widget _buildMiniProfileBox(Story story, {bool loading = false}){
    return Row(children: <Widget>[
      loading ? 
        buildShimmeringCircle(20.0)
        : GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorScreen(story.author.name, story.author.id))),
          child: buildAvatarImage(story.author.imageUrl, height: 30.0)
        ),
        SizedBox(width: 10.0,),
        loading ? 
          buildShimmeringBox(height: 20.0, width: MediaQuery.of(context).size.width * 0.7) 
          : Row(children: <Widget>[
              Text(story.author.name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal)),
              SizedBox(width: 10.0,),
              Text(
                story.dateFormatted + " \u{00B7} " +  story.readingDurationString,
                style: TextStyle(fontSize: 18.0, color: Colors.grey[600])
              )
          ],)
    ]);

  }
  Widget _buildProfileBox(Story story, {bool loading = false}){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          loading ? 
            buildShimmeringCircle(40.0)
            : GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorScreen(story.author.name, story.author.id))),
              child: buildAvatarImage(story.author.imageUrl)
            ),
            SizedBox(width: 15.0,), 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                loading ? buildShimmeringBox(height: 20.0, width: MediaQuery.of(context).size.width * 0.7) 
                : Text('נכתב על ידי',
                    style: TextStyle(color: Colors.grey[700], fontSize: 18.0),
                  ),
                GestureDetector(
                  child: loading ?
                    buildShimmeringBox(height: 20.0, width: MediaQuery.of(context).size.width * 0.7) 
                    : Text(story.author.name, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
                  onTap: () => loading ? {} : Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorScreen(story.author.name, story.author.id)))
                )
              ],
            )

    ],));
  }



  Widget _buildContent(Story story ,{bool loading = false}) {
    return loading 
    ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildShimmeringParagraph(context),
        SizedBox(height: 20.0,),
        buildShimmeringParagraph(context),
        SizedBox(height: 20.0,),

    ],)
    : Html(
      data: story.contents,
      
      defaultTextStyle: TextStyle(fontFamily: 'serif'),

      // customRender: (dom.Node node, List<Widget> children) {
      //   print(node);
      //   if (node is dom.Element) {
      //     print(node.localName);
      //     switch (node.localName) {
      //       case "hr":
      //         print('hihihi');
      //         return Column(children: children);
      //     }
      //   }
      //   return null;
      // },
      customTextStyle: (dom.Node node, TextStyle baseStyle) {
        double fontSize = 20.0;
        Color color = Colors.black;
        if (node is dom.Element) {
          switch (node.localName) {
            case "figcaption":
              fontSize = 15.0;
              color = Colors.grey[700];
            break;
            }
          
        }
        return baseStyle.merge(GoogleFonts.alef())
            .merge(TextStyle(fontSize: fontSize, height: 1.3, color: color,)); //for "figcaption" center + smaller font.  + for hr repleace with a widget
      },
      customTextAlign: (dom.Node node) {
        if (node is dom.Element) {
          switch (node.localName) {
            case "figcaption":
              return TextAlign.center;
            break;
          }
        }
        return TextAlign.right;
      },

    );
  }

  Widget _buildRatingBox(Story story, {bool loading = false}){
    return loading ? buildShimmeringBox() 
    : Row(children: <Widget>[
        Text(
          story.ratingSummary,
          style: TextStyle(fontSize: 15.0, color: Colors.grey[700])
        )

    ],);
    // return Column(children: <Widget>[
    //   Row(children: <Widget>[
    //     loading ?
    //       buildShimmeringCircle(20.0) 
    //       : buildIcon('assets/icons/heart.svg',),
    //     SizedBox(width: 5.0,),
    //     loading ?
    //       buildShimmeringBox(width: 200.0, height: 40.0)
    //       : Flexible(child: Text(story.cheersSummary, style: TextStyle(fontSize: 20.0), maxLines: 4,))
    //   ],),
    //   SizedBox(height: 10.0),
    //   Row(children: <Widget>[
    //     loading ?
    //       buildShimmeringCircle(20.0)
    //     : buildIcon('assets/icons/eye1.svg'),
    //     SizedBox(width: 5.0,),
    //     loading ?
    //       buildShimmeringBox(width: 200.0, height: 40.0)
    //       : Text(story.readCountString, style: TextStyle(fontSize: 20.0))
    //   ],)
    // ],);
  }

 


 Widget _storyOptionsMenu(Story story) => PopupMenuButton<int>(
    onSelected: (result) {
      if (result == 1) showAlertDialog(context, story);
      // setState(() { _selection = result; }); 
    },
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: Text('דיווח על תוכן לא הולם',),
      ),
     
    ],
    icon: Icon(Icons.more_vert),
    offset: Offset(0, 60),
  );


showAlertDialog(BuildContext context, Story story) {
  
  AlertDialog resultDialog = AlertDialog(
    
    content: Text("הדיווח שלך התקבל במערכת, תודה."),
    actions: [
      FlatButton(
        child: Text("סגור"),
        onPressed:  () =>  Navigator.of(context).pop(),
      ),
    ],
  );
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("ביטול"),
    onPressed:  () =>  Navigator.of(context).pop(),
  );
  
  
  Widget continueButton = FlatButton(
    child: Text("דיווח"),
    onPressed:  () {
      print('מדווח...');
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
        return resultDialog;
      },
  );
      
    }
  );

  AlertDialog questionDialog = AlertDialog(
    content: Text("האם ברצונך לדווח על התוכן של הדף \"${story.title}\" כלא הולם?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return questionDialog;
    },
  );
}












}
