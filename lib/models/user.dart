
class User {
  int id;
  String email;
  String name;
  String nameInEnglish;
  String gender;
  String deviceId;
  String authenticationToken;


  User({
    this.id,
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

