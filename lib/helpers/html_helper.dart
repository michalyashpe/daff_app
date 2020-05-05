import 'package:daff_app/helpers/style.dart';
import 'package:daff_app/models/story.dart';
import 'package:daff_app/screens/connect_screen.dart';
import 'package:daff_app/screens/stories_screen.dart';
import 'package:daff_app/screens/story_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;


class HtmlHelper {

  static Widget buildHtml(Story story, BuildContext context){
    return Html(
      data: story.contents,
      // defaultTextStyle: TextStyle(fontFamily: 'serif'),
      onLinkTap: (String s) => HtmlHelper.linkTapHandler(s, context),
      linkStyle: hyperlinkStyle,
      customTextStyle: (dom.Node node, TextStyle baseStyle) {
        double fontSize = 20.0;
        Color color;
        TextDecoration textDecoration;
        double height = 1.3;
        if (node is dom.Element) {
          if (node.localName == 'a' && node.parent.localName =='figcaption'){
            color = Colors.grey[700];
            fontSize = 15.0;
          } else if (node.localName == 'figcaption') {
            color = Colors.grey[700];
            fontSize = 15.0;
            textDecoration = TextDecoration.none;
          } 
        }
        return baseStyle.merge(GoogleFonts.alef())
            .merge(TextStyle(fontSize: fontSize, height: height, color: color, decoration: textDecoration, ));// for hr repleace with a widget
      },
      customTextAlign: (dom.Node node) {
        if (node is dom.Element) {
          if (node.localName == 'figcaption') {
            return TextAlign.center;
          }
        }
        return story.ltr ? TextAlign.left : TextAlign.right ;
      },

    );
  }

  
  static String replaceHrWithImage(String html){ 
    var document = parse(html);
    // document.getElementsByClassName('image').forEach((t) => print(t.innerHtml));
    String img = 'asset:assets/hr.png';
    document.getElementsByTagName('hr').forEach((tag) { 
      String html = '<figure class="image"><img src="$img" width="70"></figure>';
      Node newNode = parse(html).body.firstChild;
      tag.replaceWith(newNode); 
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => StoryScreen(storyId)));
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



