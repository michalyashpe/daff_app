// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';

String notificationUrl = '';

class FirebaseAPI extends ChangeNotifier {
  bool isLoading = false;
  String deviceToken = "";
  // FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  // String url;

  void initialize() {
    // initFirebase();
    // initDeviceToken();
  }
  // void initFirebase() {
  // _firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) {
  //       print('on message $message');
  //       showStory(message);
  //       return;
  //     },
  //     onResume: (Map<String, dynamic> message) {
  //       print('on resume $message');
  //       showStory(message);
  //       return;

  //     },
  //     onLaunch: (Map<String, dynamic> message) {
  //       print('on launch $message');
  //       showStory(message);
  //       return;
  //     },
  //   );
  // }

  void showStory(Map<String, dynamic> message) {
    notificationUrl = message['data']['url'];
    print(notificationUrl);
    notifyListeners();
    // _launchURL(url: message['data']['url']);
  }

  // void initDeviceToken(){
  //   isLoading = true;
  //   _firebaseMessaging.getToken().then((token){
  //     deviceToken = token;
  //   });
  //   isLoading = false;
  // }

  // void _launchURL({String url = 'https://daff.co.il/users/sign_up'}) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // Future<bool> getDeviceTokenFromSP() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String deviceToken = prefs.getString('deviceToken') ?? 0;
  //   return (deviceToken != null);
  // }

}
