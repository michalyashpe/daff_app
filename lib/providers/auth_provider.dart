import 'package:flutter_facebook_login/flutter_facebook_login.dart';
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
  bool fromOfferScreen = false;

  List<String> errors = List<String>();
  bool firstLogin = false;
  bool newAccount = true;
  
  String email;
  String password;
  bool isLoading = false;

  static final FacebookLogin facebookSignIn = new FacebookLogin();


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
    facebookLogOut();
    user.disconnect();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
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
  }

  Future<int> emailLogin() async {
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

  Future<int> emailSignUp() async {
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



    Future<Null> facebookLogin() async {
      final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final FacebookAccessToken accessToken = result.accessToken;
          print('''
            Logged in!
            Token: ${accessToken.token}
            User id: ${accessToken.userId}
            Expires: ${accessToken.expires}
            Permissions: ${accessToken.permissions}
            Declined permissions: ${accessToken.declinedPermissions}
            ''');
          break;
        case FacebookLoginStatus.cancelledByUser:
          print('Login cancelled by the user.');
          break;
        case FacebookLoginStatus.error:
          print('Something went wrong with the login process.\n'
                'Here\'s the error Facebook gave us: ${result.errorMessage}');
          break;
      }
    }

  Future<Null> facebookLogOut() async {
    bool loggedIn = await facebookSignIn.isLoggedIn;
    print('facebookSignIn.isLoggedIn');
    print(loggedIn);
    if (loggedIn) await facebookSignIn.logOut();
    print('Logged out.');
  }


}