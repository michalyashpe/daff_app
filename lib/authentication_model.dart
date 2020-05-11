import 'package:shared_preferences/shared_preferences.dart';
import 'package:daff_app/helpers/.daff_api.dart';
import 'package:daff_app/models/user.dart';
import 'package:daff_app/providers/author_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthModel extends ChangeNotifier {
  final User user;
  AuthModel(this.user);

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


  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('authenticationToken') || prefs.get('daffServerUrl') != daffServerUrl) {
      print('autoLogin failed');
      return false;
    }
    
    user.authenticationToken = prefs.getString('authenticationToken');
    user.email = prefs.getString('email');
    user.id = prefs.getInt('id');
    user.author = await AuthorProvider().fetchAuthorData(user.id);

    notifyListeners();
    print('autoLogin succeeded');
    return true;
  }

  void logOut() async {
    user.disconnect();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }


  void submitAuth(){
    setSharedPerencesAuthData();
  }

  void setSharedPerencesAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('authenticationToken', user.authenticationToken);
    prefs.setString('email', user.email);
    prefs.setInt('id', user.id);
    prefs.setString('daffServerUrl', daffServerUrl);
    print('saved login for user');
  }

  Future<int> login() async {
    initialize();
    print('trying to logIn with: $email / $password');
    int status;
    isLoading = true;
    notifyListeners();
    http.Response response = await http.post(
      daffServerUrl + '/users/sign_in.json',
      headers: <String, String>{
        'authorization': basicAuth,
      },
      body:{
        'user[email]': email,
        'user[password]': password
      });
      status = response.statusCode;
      Map<String, dynamic> result = json.decode(response.body);
      if(result['error'] != null ) errors.add(result['error']);
      if (status == 200) { 
        user.authenticationToken = result['authentication_token'];
        user.email =  email;
        user.id = result['user_id'];
        user.author = await AuthorProvider().fetchAuthorData(user.id);
        submitAuth();
      }
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
