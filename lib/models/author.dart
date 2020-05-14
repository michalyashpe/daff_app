
import 'package:daff_app/models/story.dart';

class Author {
  String name;
  int id;
  String imageUrl;
  int cheersCount;
  int readsCount;
  int storiesCount;
  String gender;
  String copyrightsLine;
  String aboutMe;

  List<Story> stories = List<Story>();

  Author({
    this.name,
    this.id,
    this.stories,
    this.imageUrl,
    this.cheersCount,
    this.readsCount,
    this.storiesCount,
    this.gender,
    this.copyrightsLine,
    this.aboutMe
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
    cheersCount: author['cheers_count'],
    readsCount: author['readings_count'],
    storiesCount: author['stories_count'],
    aboutMe: author['about_me'],
    gender: author['gender'],
    copyrightsLine: author['copyrights_line'],
    stories: stories
  );
  }


Map<Author, int> parseCheerersFromJson(List<dynamic> cheerersData){
  Map<Author, int> cheerersList = Map<Author, int>();
  cheerersData.forEach((cheerer) {
    Author author = Author(
      name: cheerer['safe_name'],
      id: cheerer['id']
    );
    cheerersList[author] = cheerer['amount'];
  });
  return cheerersList;
}