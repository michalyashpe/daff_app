import 'package:daff_app/authentication_model.dart';
import 'package:daff_app/helpers/firebase_api.dart';
import 'package:daff_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(  MyApp());

class MyApp extends StatefulWidget {
  MyApp();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAPI firebaseAPI;
  void initState() {
    super.initState();
    firebaseAPI = FirebaseAPI();
    firebaseAPI.initialize();
  }
  _MyAppState();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationModel()),
        ChangeNotifierProvider(create: (_) => firebaseAPI),
          
      ],
  child: MaterialApp(
      title: 'Daff Rocking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(firebaseAPI),
    ));
  }
}
