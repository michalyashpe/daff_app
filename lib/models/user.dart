import 'package:daff_app/models/author.dart';
import 'package:daff_app/models/comment.dart';
import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/author_provider.dart';

class User {
  int id;
  Author author;
  String email;
  String name;
  String nameInEnglish;
  String gender;
  String deviceId;
  String authenticationToken;

  User({
    this.id,
    this.author,
    this.email,
    this.name,
    this.nameInEnglish,
    this.gender,
    this.deviceId,
    this.authenticationToken,
  });

  bool get connected {
    return authenticationToken != null;
  }

  Future<void> connect(
      {String loginToken, int loginId, String loginEmail}) async {
    authenticationToken = loginToken;
    id = loginId;
    email = loginEmail;
    author = await AuthorProvider().fetchAuthorData(id);
  }

  void disconnect() {
    //reset all but deviceId;
    authenticationToken = null;
    id = null;
    author = null;
    email = null;
    name = null;
    nameInEnglish = null;
    gender = null;
  }

  bool cheeredStory(Story story) {
    return story.cheerers.keys.where((Author a) => a.id == id).length > 0;
  }

  bool commentedStory(Story story) {
    return story.comments.where((Comment c) => c.author.id == id).length > 0;
  }
}
