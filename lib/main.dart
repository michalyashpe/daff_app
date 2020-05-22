library crashy;

import 'dart:async';

import 'package:daff_app/helpers/dsn.dart';
import 'package:daff_app/providers/user_provider.dart';
import 'package:daff_app/providers/story_provider.dart';
import 'package:daff_app/screens/splash_screen.dart';
import 'package:daff_app/screens/stories_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry/sentry.dart';
import 'package:daff_app/providers/auth_provider.dart';
import 'package:daff_app/helpers/firebase_api.dart';
import 'package:daff_app/providers/author_provider.dart';
import 'package:daff_app/providers/stories_provider.dart';
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
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZoned<Future<Null>>(() async {
    runApp(new MyApp());
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
  UserProvider userProvider;

  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));

    super.initState();
    firebaseAPI = FirebaseAPI();
    firebaseAPI.initialize();
    userProvider = UserProvider();
    userProvider.initialize();
  }


  _MyAppState();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthModel(userProvider.user)),
        ChangeNotifierProvider(create: (_) => firebaseAPI),
        ChangeNotifierProvider(create: (_) => StoryProvider(userProvider.user)),
        ChangeNotifierProvider(create: (_) => StoriesModel(userProvider.user)),
        ChangeNotifierProvider(create: (_) => userProvider),
        ChangeNotifierProvider(create: (_) => AuthorProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate
          ],
          supportedLocales: [
            const Locale('he'), // Hebrew
          ],
          locale: Locale("he", "HE") ,
          title: 'Daff Rocking App',
          theme: ThemeData(
            primarySwatch: Colors.grey,
            fontFamily: GoogleFonts.alef().fontFamily,
            textTheme:  TextTheme(
                body1: TextStyle(fontSize: 16.0),
              ),
          ),
          home: Directionality( 
            textDirection: TextDirection.rtl,
            child: Consumer<AuthModel>( builder: (BuildContext context, AuthModel authModel, Widget child) {
              return authModel.user.connected ?  StoriesScreen('בית', 'hits=true')
              : FutureBuilder(
                future: authModel.tryAutoLogin(),
                builder: (ctx, authResultSnapshot) =>
                  authResultSnapshot.connectionState == ConnectionState.waiting
                    ? SplashScreen()
                    : SplashScreen(),
                );
            })
          ),
        )
    );
  }
}

