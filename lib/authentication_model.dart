
import 'package:daff_app/helpers/daff_api.dart';
import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AuthenticationModel extends ChangeNotifier {
  String email;
  String password;
  User user;
  bool isLoading = false;

  Future<int> daffLogin(String deviceToken) async { // move to seperate model?
    Map<String,String> userData = {
      'email': email ,
      'password': password,
      'deviceToken': deviceToken
    };
    int status;
    isLoading = true;
    notifyListeners();
    await http.post(
      daffServerUrl + '/users/sign_in.json',
      headers: {
        'Content-type': 'application/json',
      },
      body: json.encode({'user': userData}))
      .then((http.Response response) {
        status = response.statusCode;
        if (status == 200) { 
          Map<String, dynamic> result = json.decode(response.body);
          user = User(
            email: result['user']['email'],
            name: result['user']['name'],
            nameInEnglish: result['user']['name_in_english'],
            gender: result['user']['gender'],
          );
          // addDeviceTokenToSP(deviceToken);
          //show user message - thanks and we'll send you updates with new stories
          //maybe notification settings page?
        }
        if (status == 302) { 
          //let user know login failed, and why
        }
      });
      isLoading = false;
      notifyListeners();
      return status;

  }

  // void addDeviceTokenToSP(String deviceToken) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('deviceToken', deviceToken);
  // }


}

class User {
  int id;
  String email;
  String name;
  String nameInEnglish;
  String gender;

  User({
    this.id,
    this.email,
    this.name,
    this.nameInEnglish,
    this.gender,
  });
}