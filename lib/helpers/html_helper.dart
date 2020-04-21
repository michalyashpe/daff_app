import 'package:html/parser.dart';

class HtmlHelper {
  static String removeInnerTags(String tagName, String html){
    var document = parse(html);
    document.getElementsByTagName(tagName).forEach((tag) {
      tag.innerHtml = tag.text;
    });
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
}