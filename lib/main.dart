library crashy;

import 'dart:async';

import 'package:daff_app/helpers/dsn.dart';
import 'package:daff_app/providers/audio_player_provider.dart';
import 'package:daff_app/screens/splash_screen.dart';
import 'package:daff_app/widgets/audio_player/audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry/sentry.dart';
import 'package:daff_app/authentication_model.dart';
import 'package:daff_app/helpers/firebase_api.dart';
import 'package:daff_app/providers/author_screen_provider.dart';
import 'package:daff_app/providers/stories_provider.dart';
import 'package:daff_app/providers/story_screen_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final SentryClient _sentry = new SentryClient(dsn: dsn);

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

/// Reports [error] along with its [stackTrace] to Sentry.io.
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print('Caught error: $error');

  // Errors thrown in development mode are unlikely to be interesting. You can
  // check if you are running in dev mode using an assertion and omit sending
  // the report.
  if (isInDebugMode) {
    print(stackTrace);
    print('In dev mode. Not sending report to Sentry.io.');
    return;
  }

  print('Reporting to Sentry.io...');

  final SentryResponse response = await _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    print('Success! Event ID: ${response.eventId}');
  } else {
    print('Failed to report to Sentry.io: ${response.error}');
  }
}

Future<Null> main() async {
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZoned<Future<Null>>(() async {
    runApp(new MyApp());
    // runApp(AudioPlayerApp());
  }, onError: (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}



class MyApp extends StatefulWidget {
  MyApp();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAPI firebaseAPI;
  StoriesModel storiesModel ;
  AudioPlayerProvider audioPlayerProvider;
  

  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));

    super.initState();
    firebaseAPI = FirebaseAPI();
    firebaseAPI.initialize();
    storiesModel = StoriesModel();
    audioPlayerProvider = AudioPlayerProvider();
    // queueHelper.initalize();
    // audioPlayerProvider.deleteAll();
    

    // homeModel = HomeModel();
    // homeModel.initialize();
    
  }


  _MyAppState();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationModel()),
        ChangeNotifierProvider(create: (_) => firebaseAPI),
        ChangeNotifierProvider(create: (_) => StoryModel()),
        ChangeNotifierProvider(create: (_) => audioPlayerProvider),
        ChangeNotifierProvider(create: (_) =>  storiesModel),
        ChangeNotifierProvider(create: (_) =>  AuthorModel()),
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
      child: SplashScreen(),
    ),
    routes: {
    },
  ));
  }
}
