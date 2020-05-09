
import 'package:daff_app/models/author.dart';

class User {
  int id;
  Author author;
  String email;
  String name;
  String nameInEnglish;
  String gender;
  String deviceId;
  String authenticationToken;


  User ({
    this.id,
    this.author,
    this.email,
    this.name,
    this.nameInEnglish,
    this.gender,
    this.deviceId,
    this.authenticationToken
  });

  bool get connected {
    return authenticationToken != null;
  }

}

