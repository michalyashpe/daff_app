import 'package:daff_app/helpers/html_helper.dart';
import 'package:daff_app/helpers/style.dart';
import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/story_provider.dart';
import 'package:daff_app/screens/author_screen.dart';
import 'package:daff_app/widgets/app_logo.dart';
import 'package:daff_app/widgets/avatar_widget.dart';
import 'package:daff_app/widgets/divider.dart';
import 'package:daff_app/widgets/editor_pick_widget.dart';
import 'package:daff_app/widgets/social_bar.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:daff_app/widgets/story_tags_widget.dart';
import 'package:daff_app/widgets/user_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoryContent extends StatefulWidget {
  final Story story;
  StoryContent(this.story);

  @override
  _StoryContentState createState() => _StoryContentState();
}

class _StoryContentState extends State<StoryContent> {
  Story story;
  double padding = 10.0;
  ScrollController _scrollController;
  bool _showBottomSocialBar = false;

  @override
  void initState() {
    story = widget.story;
    _scrollController = ScrollController();
    _scrollController.addListener(() => toggleSocialBar());
    super.initState();
  }

  double _animatedSocialBarHeight;
  void toggleSocialBar() {
    double pageSize = _scrollController.position.maxScrollExtent;
    if (_scrollController.position.pixels < 10.0 ||
        _scrollController.position.pixels > (pageSize * 0.5) &&
            !_showBottomSocialBar) {
      setState(() {
        _showBottomSocialBar = true;
        _animatedSocialBarHeight = socialBarHeight;
      });
    } else if (_scrollController.position.pixels > 10 &&
        _scrollController.position.pixels < pageSize * 0.5 &&
        _showBottomSocialBar) {
      setState(() {
        _showBottomSocialBar = false;
        _animatedSocialBarHeight = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomScrollView(controller: _scrollController, slivers: <Widget>[
          SliverAppBar(
            // expandedHeight: 70.0,
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(color: Colors.grey),
            floating: true,
            pinned: false,
            snap: true,
            backgroundColor: Theme.of(context).backgroundColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
            title: GestureDetector(
                onTap: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: buildMiniLogo()),
            centerTitle: true,
            actions: <Widget>[
              buildUserAvatar(context),
            ],
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 15.0,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: _buildTitle()),
            story.isSytemUpdate
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Text('מערכת הדף',
                        style:
                            TextStyle(fontSize: 20.0, color: Colors.grey[700])))
                : SizedBox(height: 0.0),
            SizedBox(
              height: 10.0,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: _buildMiniProfileBox()),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: _buildContent(),
            ),
            SizedBox(
              height: 40.0,
            ),

            Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        flex: 9,
                        child: buildStoryTagsWidget(story.tags, context,
                            fontSize: 18.0)),
                    Flexible(flex: 1, child: _storyOptionsMenu()),
                  ],
                )),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: _buildRatingBox(),
            ),
            // _buildMoreStories(context),
            SizedBox(
              height: 10.0,
            ),
            buildDivider(5.0),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: _buildProfileBox()),
            buildDivider(5.0),

            Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: _buildRecommendedStories()),
            SizedBox(height: socialBarHeight),

            story.hasAudio ? SizedBox(height: playerWidgetHeight) : SizedBox(),
          ]))
        ]),
        Positioned(
            bottom: story.hasAudio ? playerWidgetHeight : 0.0,
            child: AnimatedContainer(
                height: _animatedSocialBarHeight,
                curve: Curves.fastOutSlowIn,
                duration: const Duration(milliseconds: 300),
                child: buildSocialBar(context, story)))
      ],
    );
  }

  Widget _buildTitle() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Text(
          story.title,
          maxLines: 3,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
          // overflow: TextOverflow.fade,
        ),
        SizedBox(
          width: 3.0,
        ),
        buildEditerPickMedalWidget(story, size: 30.0),
      ],
    );
  }

  Widget _buildRecommendedStories() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 15.0,
        ),
        Text(
          'מומלצים:',
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 20.0, color: Colors.grey[700]),
        ),
        SizedBox(
          height: 5.0,
        ),
        Column(
          children: story.recommended
              .map((Story s) => [
                    SizedBox(height: 5.0),
                    buildStoryPreviewWidget(s, context),
                  ])
              .expand((i) => i)
              .toList(),
        ),
      ],
    ));
  }

  Widget _buildMiniProfileBox() {
    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AuthorScreen(story.author.name, story.author.id))),
        child: Wrap(
            spacing: 5.0,
            // runSpacing: ,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              buildAvatarImage(story.author.imageUrl, height: 30.0),
              Text(story.author.name,
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal)),
              Text(
                  story.dateFormatted +
                      " \u{00B7} " +
                      story.readingDurationString,
                  style: TextStyle(fontSize: 18.0, color: Colors.grey[600]))
            ]));
  }

  Widget _buildProfileBox() {
    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AuthorScreen(story.author.name, story.author.id))),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildAvatarImage(story.author.imageUrl),
                SizedBox(
                  width: 15.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'נכתב על ידי',
                      style: TextStyle(color: Colors.grey[700], fontSize: 17.0),
                    ),
                    Text(story.author.name,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    story.author.aboutMe != null && story.author.aboutMe != ''
                        ? Container(
                            width: MediaQuery.of(context).size.width - 150.0,
                            child: Text(
                              story.author.aboutMe,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : SizedBox(),
                  ],
                )
              ],
            )));
  }

  Widget _buildContent() {
    story.contents = HtmlHelper.replaceHrWithImage(story.contents);
    return HtmlHelper.buildHtml(story, context);
  }

  Widget _buildRatingBox() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Text(story.ratingSummary,
                style: TextStyle(fontSize: 15.0, color: Colors.grey[700]))),
      ],
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog resultDialog = AlertDialog(
      content: Text("הדיווח שלך התקבל במערכת, תודה."),
      actions: [
        FlatButton(
          child: Text("סגור"),
          onPressed: () => Navigator.of(
            context,
          ).pop(),
        ),
      ],
    );

    Widget cancelButton = FlatButton(
      child: Text("ביטול"),
      onPressed: () => Navigator.of(context).pop(),
    );

    Widget continueButton = FlatButton(
        child: Text("דיווח"),
        onPressed: () {
          Provider.of<StoryProvider>(context, listen: false)
              .reportContent(story.id);
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return resultDialog;
            },
          );
        });

    AlertDialog questionDialog = AlertDialog(
      content:
          Text("האם ברצונך לדווח על התוכן של הדף \"${story.title}\" כלא הולם?"),
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

  Widget _storyOptionsMenu() => PopupMenuButton<int>(
        onSelected: (result) {
          if (result == 1) showAlertDialog(context);
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(
              'דיווח על תוכן לא הולם',
            ),
          ),
        ],
        icon: Icon(Icons.more_vert),
        offset: Offset(0, 60),
      );
}
