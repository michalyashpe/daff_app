import 'package:daff_app/authentication_model.dart';
import 'package:daff_app/helpers/firebase_api.dart';
import 'package:daff_app/providers/home_screen_provider.dart';
import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:daff_app/screens/home_screen.dart';
// import 'package:daff_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// import 'package:flutter_cupertino_localizations/flutter_cupertino_localizations.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAPI firebaseAPI;
  HomeModel homeModel;

  void initState() {
    super.initState();
    firebaseAPI = FirebaseAPI();
    firebaseAPI.initialize();
    homeModel = HomeModel();
    homeModel.initialize();
  }


  _MyAppState();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationModel()),
        ChangeNotifierProvider(create: (_) => firebaseAPI),
        ChangeNotifierProvider(create: (_) => homeModel),
        ChangeNotifierProvider(create: (_) => StoryModel()),
          
      ],
  child: MaterialApp(

    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      // GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('he'), // Hebrew
    ],
    locale: Locale("he", "HE") ,



      title: 'Daff Rocking App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        textTheme: GoogleFonts.alefTextTheme(Theme.of(context).textTheme,),
      ),
      home: Directionality( // add this
        textDirection: TextDirection.rtl, // set this property 
        child: HomeScreen(),//LoginScreen(firebaseAPI),
      )
    ));
  }
}
