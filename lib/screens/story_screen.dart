import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/story_provider.dart';
import 'package:daff_app/widgets/player_widget.dart';
import 'package:daff_app/widgets/shimmering_box.dart';
import 'package:daff_app/widgets/story_content.dart';
import 'package:daff_app/widgets/story_tags_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoryScreen extends StatefulWidget {
  final int storyId;
  StoryScreen(this.storyId);
  static const routeName = '/story_screen';
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  PlayerWidget audioPlayer;
  Story story;

  @override
  void initState() {
    initializeStory();
    super.initState();
  }

  void initializeStory() async {
    story = await Provider.of<StoryProvider>(context, listen: false)
        .fetchStoryData(widget.storyId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
        builder: (BuildContext context, StoryProvider model, Widget child) {
      return Scaffold(
        body: !model.isLoading && story != null ? StoryContent(story) : buildStoryContentShimmeringBoxes(),
        bottomSheet: !model.isLoading && story != null && story.hasAudio
            ? PlayerWidget(story: story)
            : SizedBox(),
      );
    });
  }

  Widget buildStoryContentShimmeringBoxes() {
    return Column(children: <Widget>[
      AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              //title
              buildShimmeringBox(
                  height: 40.0, width: MediaQuery.of(context).size.width * 0.7),

              //mini profile box
              Row(
                children: <Widget>[
                  buildShimmeringCircle(20.0),
                  buildShimmeringBox(
                      height: 20.0,
                      width: MediaQuery.of(context).size.width * 0.7)
                ],
              ),

              // content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildShimmeringParagraph(context),
                  SizedBox(
                    height: 20.0,
                  ),
                  buildShimmeringParagraph(context),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
              buildStoryTagsWidgetLoader(),
              SizedBox(height: 20.0),
              buildShimmeringBox(), // rating box
              //big profile box
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildShimmeringCircle(30.0),
                    SizedBox(
                      width: 15.0,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          buildShimmeringBox(
                              height: 20.0,
                              width: MediaQuery.of(context).size.width * 0.7),
                          buildShimmeringBox(
                              height: 20.0,
                              width: MediaQuery.of(context).size.width * 0.7)
                        ])
                  ]),
              // recommneded stories
              buildShimmeringBox(height: 50.0),
              buildShimmeringBox(height: 50.0),
              buildShimmeringBox(height: 50.0),
            ],
          ))
    ]);
  }
}

// Widget _buildBottomSheet({bool loading = false}){
//   if (!loading) {
//     if (story.hasAudio){
//       audioPlayer = PlayerWidget(story: story);
//       _showBottomSocialBar = false; //TODO: enable social bar on stories with audio
//     }
//     socialBarHeight =  _scrollController.position.pixels > 200.0 ? 60.0 : 0.0;

//   }
//   return loading ? Text('')
//     : Container(
//       height: _showBottomSocialBar && story.hasAudio ? (playerWidgetHeight + socialBarHeight)
//         : story.hasAudio ? playerWidgetHeight
//         : _showBottomSocialBar ? socialBarHeight
//         : 0.0,
//       child: Column(children: <Widget>[
//       story.hasAudio ? audioPlayer : SizedBox(),
//       _showBottomSocialBar ? _buildSocialBar(socialBarHeight) : SizedBox()
//       ],));
// }

//  Widget _storyOptionsMenu() => PopupMenuButton<int>(
//     onSelected: (result) {
//       if (result == 1) showAlertDialog(context);
//       if (result == 2) share();
//     },
//     itemBuilder: (context) => [
//       PopupMenuItem(
//         value: 2,
//         child: Row(children: <Widget>[
//           Text(' שיתוף',),
//           ],)
//       ),
//         PopupMenuItem(
//           value: 1,
//           child: Text('דיווח על תוכן לא הולם',),
//         ),
//       ],
//     icon: Icon(Icons.more_vert),
//     offset: Offset(0, 60),
//   );
