
import 'package:daff_app/helpers/.daff_api.dart';
import 'package:daff_app/models/user.dart';
import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AuthenticationModel extends ChangeNotifier {
  final User user;
  AuthenticationModel(this.user);

  List<String> errors = List<String>();
  bool firstLogin = false;
  bool newAccount = true;
  
  String email;
  String password;
  bool isLoading = false;
  

  void initialize({bool firstTime = false}){
    if (firstTime) {
      email = '';
      password = '';
    }
    firstLogin = false;
    errors = List<String>();
  }



  Future<int> logIn() async {
    initialize();
    print('trying to logIn with: $email / $password');
    int status;
    isLoading = true;
    notifyListeners();
    await http.post(
      daffServerUrl + '/users/sign_in.json',
      headers: <String, String>{
        'authorization': basicAuth,
      },
      body:{
        'user[email]': email,
        'user[password]': password
      }).then((http.Response response) {
        status = response.statusCode;
        Map<String, dynamic> result = json.decode(response.body);
        print(result);
        if(result['error'] != null ) errors.add(result['error']);
        if (status == 200) { 
          user.authenticationToken = result['authentication_token'];
          user.email =  email;
        }
      });
      isLoading = false;
      notifyListeners();
      return status;

  }

  Future<int> signUp() async {
    initialize();
    print('trying to signUp with: $email / $password');
    int status;
    isLoading = true;
    notifyListeners();
    await http.post(
      daffServerUrl + '/users.json',
      headers: <String, String>{
        'authorization': basicAuth,
      },
      body:{
        'user[doar]': email,
        'user[password]': password
      }).then((http.Response response) {
        status = response.statusCode;
        Map<String, dynamic> result = json.decode(response.body);
        print(result);
        if(result['errors'] == 'inactive_sign_up') {
          firstLogin = true;
          newAccount = false;
        }
        else if(result['errors']['password'] != null ) result['errors']['password'].forEach((e) => errors.add('סיסמה לא תקינה: $e'));
        else if(result['errors']['email'] != null ) result['errors']['email'].forEach((e) => errors.add(' כתובת מייל לא תקינה: $e'));
        if (status == 200) { 
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
