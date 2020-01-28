
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
}


Author parseAuthorFromJson(Map<String, dynamic> user){
  return Author(
    id: user['id'],
    name: user['name'],
    imageUrl: user['avatar']
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