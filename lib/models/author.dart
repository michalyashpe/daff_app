
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

  int get cheersCount {
    return 50; //TODO: get this from the server
    // if (stories == null) return 0;
    // int totalCheers = 0;
    // print(stories.first.cheersCount);
    // stories.forEach((Story s) => totalCheers += s.cheersCount);
    // return totalCheers;
  }

  int get readsCount {
    if (stories == null) return 0;
    int readsCount = 0;
    stories.forEach((Story s) => readsCount += s.readCount);
    return readsCount;
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