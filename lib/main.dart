import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'firebase_options.dart';
import 'screens/auth/splash_screen.dart';

AppThemeData theme = AppThemeData();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // SYSTEM  Orientation
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
  );
  theme.init(true);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppThemeData(),
      child: Consumer<AppThemeData>(
        builder: (context, value, child) {
          var mainTheme = ThemeData(
            primarySwatch: value.primarySwatch,
            primaryColor: value.buttonColor,
            hoverColor: theme.textColorDefault,
            textSelectionTheme: TextSelectionThemeData(
              selectionHandleColor: theme.buttonColor,
              cursorColor: theme.buttonColor,
              selectionColor: theme.buttonColor,
            ),
          );
          if (value.darkMode) {
            mainTheme = ThemeData(
              brightness: Brightness.dark,
              primarySwatch: value.primarySwatch,
              primaryColor: value.buttonColor,
              textSelectionTheme: TextSelectionThemeData(
                selectionHandleColor: value.buttonColor,
                cursorColor: theme.buttonColor,
              ),
            );
          }
          return MaterialApp(
            theme: mainTheme,
            title: "Paint_Scan",
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
