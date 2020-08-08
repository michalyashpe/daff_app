import 'package:daff_app/helpers/style.dart';
import 'package:daff_app/models/story.dart';
import 'package:daff_app/models/user.dart';
import 'package:daff_app/providers/story_provider.dart';
import 'package:daff_app/screens/comments_screen.dart';
import 'package:daff_app/screens/new_comment_screen.dart';
import 'package:daff_app/screens/offer_connect_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

Widget buildSocialBar(BuildContext context, Story story) {
  void share() {
    final RenderBox box = context.findRenderObject();
    Share.share(story.shareText,
        subject: 'חשבתי שיעניין אותך לקרוא',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  User user = Provider.of<StoryProvider>(context, listen: false).user;
  bool cheered = user.cheeredStory(story);
  bool commented = user.commentedStory(story);

  return Container(
      width: MediaQuery.of(context).size.width,
      height: socialBarHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              onPressed: () => user.connected
                  ? Provider.of<StoryProvider>(context, listen: false)
                      .cheer(story)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OfferConnectScreen())),
              icon: buildCounterIcon(
                  icon: Icon(
                      story.cheersCount == 0
                          ? Icons.favorite_border
                          : Icons.favorite,
                      size: 26.0,
                      color: cheered ? Colors.grey[800] : socialBoxIconsColor),
                  counter: story.cheersCount),
            ),
            IconButton(
              icon: buildCounterIcon(
                  icon: FaIcon(
                    story.comments.length == 0
                        ? FontAwesomeIcons.comment
                        : FontAwesomeIcons.solidComment,
                    size: 22.0,
                    color: commented ? Colors.grey[800] : socialBoxIconsColor,
                  ),
                  counter: story.comments.length),
              onPressed: () {
                !user.connected && story.comments.length == 0
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OfferConnectScreen()))
                    : user.connected && story.comments.length == 0
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewCommentScreen(story)))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentsScreen(story)));
              },
            ),
            IconButton(
              onPressed: () => share(),
              icon: Icon(Icons.share, size: 23.0, color: socialBoxIconsColor),
              // icon: FaIcon(FontAwesomeIcons.shareAlt,size: 20.0, color: socialBoxIconsColor),
            )
          ]));
}

Widget buildCounterIcon({Widget icon, int counter}) {
  return Stack(children: <Widget>[
    icon,
    // Positioned.fill(
    //   child: Align(
    //       alignment: Alignment.center,
    //       widthFactor: 100.0,
    //       child: Text(counter > 0 ? counter.toString() : '',
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //               fontSize: 8.0,
    //               fontFamily: GoogleFonts.montserrat().fontFamily,
    //               color: Colors.grey[300],
    //               fontWeight: FontWeight.w700))),
    // ),
  ]);
}
