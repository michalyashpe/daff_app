import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseAPI extends ChangeNotifier {
  bool isLoading = false;
  String deviceToken;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  void initialize(){
    initFirebase();
    initDeviceToken();
  }


  void initFirebase() {
  _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("**************");
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~");
        print('on resume $message');
        print(message['data']['url']);
        // _launchURL(url: message['data']['url']);

      },
      onLaunch: (Map<String, dynamic> message) {
        print("^^^^^^^^^^^^^^^^^^^^");
        print('on launch $message');
      },
    );
  }


  void initDeviceToken(){
    isLoading = true;
    _firebaseMessaging.getToken().then((token){
      deviceToken = token;
    });
    isLoading = false;
    notifyListeners();
  }



}