
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AuthenticationModel extends ChangeNotifier {
  String email;
  String password;

  void daffLogin(String deviceToken){ // move to seperate model?
    Map<String,String> answer = {
      'email': email ,
      'password': password,
      'deviceToken': deviceToken
    };
    print('asnwer: ' + answer.toString());
    //  http.post(
    //     daffServerUrl + '/auth',
    //     headers: {
    //       'Content-type': 'application/json',
    //       // 'access-token': userCreds.accessToken,
    //       // 'client': userCreds.client,
    //       // 'uid':  userCreds.uid,
    //     },
    //     body: json.encode(answer))
    //     .then((http.Response response) {
    //       print(json.decode(response.body));
    //     });

  
  }
}