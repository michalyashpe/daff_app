import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/screens/connect_screen.dart';
import 'package:daff_app/screens/stories_screen.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlHelper {
  static String removeInnerTags(String tagName, String html){ //TODO: style links in figcaption
    var document = parse(html);
    // document.getElementsByTagName(tagName).forEach((tag) {
    //   tag.innerHtml = tag.text;
    // });
    return document.outerHtml;  
  }
  
  static String replaceHrWithImage(String html){ //TODO: replace hr with image
    // print(html);
    var document = parse(html);
    document.getElementsByClassName('image').forEach((t) => print(t.innerHtml));
    
    document.getElementsByTagName('hr').forEach((tag) {
      tag.innerHtml = '<img src="https://images.unsplash.com/photo-151>';
    });
    return document.outerHtml;  
  }

  static void linkTapHandler(String url, BuildContext context){
    if(!url.contains('daff.co.il')){
       _launchURL(url);
    } else {
      String cleanUrl= url.replaceAll('https://', '').replaceAll('daff.co.il', '');
      if (cleanUrl =='')  Navigator.of(context).push(MaterialPageRoute(builder: (context) => StoriesScreen('בית', 'hits=true')));
      else if (cleanUrl == '/stories') Navigator.push(context, MaterialPageRoute(builder: (context) => StoriesScreen('כל הסיפורים', '')));
      else if (cleanUrl == '/users/sign_up') Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectScreen()));
      else if (cleanUrl.contains(('with_audio=true'))) Navigator.of(context).push(MaterialPageRoute(builder: (context) => StoriesScreen('דפים מוקלטים', 'with_audio=true')));
      else if (cleanUrl.contains('editor_votes=true')) Navigator.of(context).push(MaterialPageRoute(builder: (context) => StoriesScreen('בחירות העורך', 'editor_votes=true')));
      else if (cleanUrl.contains('stories?tag')){
        final match = RegExp(r"tag=(\w+)").firstMatch(cleanUrl);
        if (match != null) {
          String tag = match[1];
          Navigator.push(context, MaterialPageRoute(builder: (context) => StoriesScreen(tag, 'tag=$tag')));
        }
      } else { //link to story
        final match = RegExp(r"stories\/(\d+)").firstMatch(cleanUrl);
        if (match != null) {
          int storyId = int.parse(match[1]);
          Provider.of<StoryModel>(context, listen: false).initialize(storyId);
          Navigator.push(context, MaterialPageRoute(builder: (context) => StoryScreen('')));
        } else {
          print("$url is not supported in app, redirecting to homepage");
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => StoriesScreen('בית', 'hits=true')));
        }
      }
    }  
  }

  static Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
    
  }



