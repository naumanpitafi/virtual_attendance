import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:virtual_attendance/providers/allProviders.dart';
import 'package:virtual_attendance/screens/splash.dart';

import 'screens/testPage.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

int? initScreen;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  // SharedPreferences preferences = await SharedPreferences.getInstance();
  // initScreen =  await preferences.getInt('initScreen');
  // await preferences.setInt('initScreen', 1); //if already shown -> 1 else 0

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return MultiProvider(
          providers: allProvider,
          child: MaterialApp(
            color: Colors.red,
            theme: ThemeData(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              bottomSheetTheme: const BottomSheetThemeData(
                  backgroundColor: Colors.transparent),
            ),
            debugShowCheckedModeBanner: false,
            home: const Splash(),
            // home: MapTestPage(),
          ),
        );
      },
    );
  }
}
