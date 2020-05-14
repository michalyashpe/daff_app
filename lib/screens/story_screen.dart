import 'package:daff_app/helpers/html_helper.dart';
import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/story_provider.dart';
import 'package:daff_app/screens/author_screen.dart';
import 'package:daff_app/screens/comments_screen.dart';
import 'package:daff_app/screens/new_comment_screen.dart';
import 'package:daff_app/screens/offer_connect_screen.dart';
import 'package:daff_app/widgets/avatar_widget.dart';
import 'package:daff_app/widgets/divider.dart';
import 'package:daff_app/widgets/editor_pick_widget.dart';
import 'package:daff_app/widgets/player_widget.dart';
import 'package:daff_app/widgets/shimmering_box.dart';
import 'package:daff_app/widgets/story_preview_widget.dart';
import 'package:daff_app/widgets/story_tags_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class StoryScreen extends StatefulWidget{
  final int storyId;
  StoryScreen(this.storyId);
  static const routeName = '/story_screen';
  _StoryScreenState createState() => _StoryScreenState();
}



class _StoryScreenState extends State<StoryScreen>{
  double padding = 10.0;
  bool _showBottomSocialBar = false ;
  double socialBarHeight = 60.0;
  ScrollController _scrollController;
  PlayerWidget audioPlayer;
  Story story;

@override
  void initState() {
    initializeStory();
    _scrollController = ScrollController();
    _scrollController.addListener(() => toggleSocialBar());

    super.initState();
  }

  void initializeStory() async {
    story = await Provider.of<StoryProvider>(context, listen: false).fetchStoryData(widget.storyId);
  }

  void toggleSocialBar() {
    double pageSize = _scrollController.position.maxScrollExtent;
    if (_scrollController.position.pixels > pageSize * 0.5 && !_showBottomSocialBar ) { //TODO: show social bar for stories with audio
      setState(() {_showBottomSocialBar = true;});
    } else if (_scrollController.position.pixels < pageSize * 0.5  && _showBottomSocialBar){
      setState(() {_showBottomSocialBar = false;});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (BuildContext context,  StoryProvider model, Widget child) {
        return Scaffold(
          bottomSheet: _buildBottomSheet(loading: model.isLoading),
          body:  CustomScrollView(
            controller: _scrollController,
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
                _storyOptionsMenu(),
              ],
            ),
            
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 15.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: _buildTitle(loading: model.isLoading)
                ),
                !model.isLoading && story.isSytemUpdate ? 
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Text('מערכת הדף', style: TextStyle(fontSize: 20.0, color: Colors.grey[700])) 
                  ) : SizedBox(height: 0.0),
                SizedBox(height: 10.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: _buildMiniProfileBox(loading: model.isLoading)
                ),
                SizedBox(height: 15.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: _buildContent(loading: model.isLoading),
                ),
                SizedBox(height: 40.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: model.isLoading 
                    ? buildStoryTagsWidgetLoader()
                    : buildStoryTagsWidget(story.tags, context,fontSize: 18.0),
                ),
                SizedBox(height: 10.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: _buildRatingBox(loading: model.isLoading),
                ),
                // _buildMoreStories(context),
                SizedBox(height: 10.0,),
                buildDivider(5.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: _buildProfileBox(loading: model.isLoading)
                ),
                buildDivider(5.0),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: _buildRecommendedStories(loading: model.isLoading)
                ),
                !model.isLoading && story.hasAudio ?
                  SizedBox(height: 70.0) : SizedBox(),
                SizedBox(height: socialBarHeight) ,
              ])
          )]
        ) );
      }
    );
  }

  Widget _buildBottomSheet({bool loading = false}){
    if (!loading) {
      if (story.hasAudio){
        audioPlayer = PlayerWidget(story: story);
        _showBottomSocialBar = false; //TODO: enable social bar on stories with audio
      }
      socialBarHeight =  _scrollController.position.pixels > 200.0 ? 60.0 : 0.0;
      
    }
    return loading ? Text('') 
      : Container(
        height: _showBottomSocialBar && story.hasAudio ? (playerWidgetHeight + socialBarHeight)
          : story.hasAudio ? playerWidgetHeight
          : _showBottomSocialBar ? socialBarHeight 
          : 0.0,
        child: Column(children: <Widget>[
        story.hasAudio ? audioPlayer : SizedBox(),
        _showBottomSocialBar ? _buildSocialBar(socialBarHeight) : SizedBox()
        ],));
  }

  Widget _buildSocialBar(double height){
    bool userConnected = Provider.of<StoryProvider>(context, listen: false).user.connected;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        IconButton(
          onPressed: () => userConnected ?  
            Provider.of<StoryProvider>(context,listen:  false).cheer(story) 
            : Navigator.push(context, MaterialPageRoute(builder: (context) => OfferConnectScreen())),
          icon: buildCounterIcon(
            icon: Icon(Icons.favorite_border, size: 30.0, color: Colors.grey[600]), 
            counter: story.cheersCount),
        ),
        IconButton(
          icon: buildCounterIcon(
            icon: FaIcon(FontAwesomeIcons.comment, size: 25.0, color: Colors.grey[600],),
            counter: story.comments.length),
          onPressed: () { 
            !userConnected && story.comments.length == 0 ? 
              Navigator.push(context, MaterialPageRoute(builder: (context) => OfferConnectScreen()))
              : userConnected && story.comments.length == 0 ? 
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewCommentScreen(story)))
                : Navigator.push(context, MaterialPageRoute(builder: (context) => CommentsScreen(story)));
          },
        ),
        IconButton(
          onPressed: () => share(),
          icon: Icon(Icons.share, size: 22.0, color: Colors.grey[600]),
        ),
      ],)
    );
  }
  
  Widget buildCounterIcon({Widget icon, int counter}){
    return Stack(
      children: <Widget>[      
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(counter > 0 ? counter.toString() : '', 
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10.0, fontFamily: GoogleFonts.montserrat().fontFamily, color: Colors.grey[600], fontWeight: FontWeight.w900))
          ),
        ),
        icon
        ]);
    
  }
  Widget _buildRecommendedStories({bool loading = false}){
    return loading ? buildShimmeringBox(height: 50.0)
    : Container( 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        SizedBox(height: 15.0,),
        Text('מומלצים:',
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 20.0, color: Colors.grey[700]),
        ),
        SizedBox(height: 5.0,),
        Column(children: story.recommended.map((Story s) => [SizedBox(height: 5.0), buildStoryPreviewWidget(s, context), ]).expand((i) => i).toList(),),
    ],)
    );
  }








  Widget _buildTitle({bool loading = false}) {
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


 
  Widget _buildMiniProfileBox({bool loading = false}){
    return 
      loading ? 
        Row(children: <Widget>[
          buildShimmeringCircle(20.0),
          buildShimmeringBox(height: 20.0, width: MediaQuery.of(context).size.width * 0.7) 
        ],)
      : GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorScreen(story.author.name, story.author.id))),
            child: Wrap(
        spacing: 5.0,
        // runSpacing: ,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
           buildAvatarImage(story.author.imageUrl, height: 30.0),
          Text(story.author.name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal)),
          Text(
            story.dateFormatted + " \u{00B7} " +  story.readingDurationString,
            style: TextStyle(fontSize: 18.0, color: Colors.grey[600])
        )
    ]));

  }
  Widget _buildProfileBox({bool loading = false}){
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorScreen(story.author.name, story.author.id))),
      child: Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          loading ? buildShimmeringCircle(30.0) : buildAvatarImage(story.author.imageUrl),
          SizedBox(width: 15.0,), 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              loading ? 
                buildShimmeringBox(height: 20.0, width: MediaQuery.of(context).size.width * 0.7) 
                : Text('נכתב על ידי',style: TextStyle(color: Colors.grey[700], fontSize: 17.0),),
              loading ?
                buildShimmeringBox(height: 20.0, width: MediaQuery.of(context).size.width * 0.7) 
                : Text(story.author.name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              !loading &&  story.author.aboutMe != null && story.author.aboutMe != '' ? 
                Container(
                  width: MediaQuery.of(context).size.width - 150.0,
                  child: Text(story.author.aboutMe, 
                    maxLines: 5, 
                    overflow: TextOverflow.ellipsis,
                  ),
                ) : SizedBox(),
            ],
          )

    ],)));
  }




  Widget _buildContent({bool loading = false}) {
    if(!loading)
      story.contents = HtmlHelper.replaceHrWithImage(story.contents);
    return loading 
    ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildShimmeringParagraph(context),
        SizedBox(height: 20.0,),
        buildShimmeringParagraph(context),
        SizedBox(height: 20.0,),
    ],)
    : HtmlHelper.buildHtml(story, context);
  }

  Widget _buildRatingBox({bool loading = false}){
    return loading ? buildShimmeringBox() 
    : Row(children: <Widget>[
        Expanded(child: Text(
          story.ratingSummary,
          style: TextStyle(fontSize: 15.0, color: Colors.grey[700])
        )),
    ],);
  }

  void share(){
    final RenderBox box = context.findRenderObject();
      Share.share(story.shareText,
        subject: 'חשבתי שיעניין אותך לקרוא',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
 }


 Widget _storyOptionsMenu() => PopupMenuButton<int>(
    onSelected: (result) {
      if (result == 1) showAlertDialog(context);
      if (result == 2) share();
    },
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 2,
        child: Row(children: <Widget>[
          Text(' שיתוף',),
          ],)
      ),
        PopupMenuItem(
          value: 1,
          child: Text('דיווח על תוכן לא הולם',),
        ),
      ],
    icon: Icon(Icons.more_vert),
    offset: Offset(0, 60),
  );


showAlertDialog(BuildContext context) {
  AlertDialog resultDialog = AlertDialog(
    content: Text("הדיווח שלך התקבל במערכת, תודה."),
    actions: [
      FlatButton(
        child: Text("סגור"),
        onPressed:  () =>  Navigator.of(context,).pop(),
      ),
    ],
  );

  Widget cancelButton = FlatButton(
    child: Text("ביטול"),
    onPressed:  () =>  Navigator.of(context).pop(),
  );
  
  
  Widget continueButton = FlatButton(
    child: Text("דיווח"),
    onPressed:  () {
      Provider.of<StoryProvider>(context, listen:  false).reportContent(story.id);
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
