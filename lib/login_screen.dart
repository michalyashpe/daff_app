import 'package:provider/provider.dart';
import 'package:daff_app/firebaseAPI_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseAPI>(
        builder: (BuildContext context,  FirebaseAPI model, Widget child) {
          return model.isLoading ? CircularProgressIndicator() :
     Scaffold(
      appBar: AppBar(
        title: Text('login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Log in'),
              onPressed: _launchURL,)
          ],
        ),
      ),
    ); });
  }


  void _launchURL({String url = 'https://daff.co.il/users/sign_up'}) async {
    await getDeviceInfo().then((String id){
      url = url + '?id=' + id;
    });
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<String> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.androidId}');
    print('----------------------');
    return androidInfo.androidId.toString();

    // IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    // print('Running on ${iosInfo.utsname.machine}');  // e.g. "iPod7,1"
  }

  
}
