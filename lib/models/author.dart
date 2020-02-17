
import 'package:daff_app/models/story.dart';

class Author {
  String name;
  String safeName;
  int id;
  String imageUrl;
  List<Story> stories = List<Story>();

  Author({
    this.name,
    this.safeName,
    this.id,
    this.stories,
    this.imageUrl
  });

  

  String get activitySummary {
    return 'פירסם ${stories.length} דפים'; 
  }

}


Author parseAuthorFromJson(Map<String, dynamic> author){
  
  List<Story> stories = List<Story>();
  if (author['stories'] != null) {
    author['stories'].forEach((story){
      Story s = parseStoryFromJson(story);
      stories.add(s);
    });
  } 
  return Author(
    id: author['id'],
    name: author['name'],
    imageUrl: author['avatar'],
    stories: stories
  );
  }


List<Author> parseCheerersFromJson(List<dynamic> cheerersData){
  List<Author> cheerersList = List<Author>();
  cheerersData.forEach((cheerer) {
    cheerersList.add(Author(
      name: cheerer['safe_name'],
      id: int.parse(cheerer['self_url'].split('/').last)
    ));
  });
  return cheerersList;
}