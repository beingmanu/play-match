import 'package:flutter/material.dart';
import 'package:blur/blur.dart';
import 'package:provider/provider.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../config/app_cache.dart';
import '../../main.dart';
import '../../models/user_model.dart';
import '../../provider/user_provider.dart';
import '../../services/auth_service.dart';
import '../../utils/navigator_helper.dart';
import '../home/home_dashboard.dart';
import 'intro_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService auth = AuthService();
  AppCache cache = AppCache();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  startApp() {
    Future.delayed(const Duration(seconds: 2)).then(
      (value) {
        removeAllAndPush(context, const IntroScreen());
      },
    );
  }

  Future<void> getCurrentUser() async {
    final user = auth.firebaseAuth.currentUser;

    var token = await cache.getToken();

    if (user != null && token != "") {
      final phone = user.phoneNumber!.substring(user.phoneNumber!.length - 10);

      await auth.getUserData(phone).then((value) async {
        if (value == "NewUser") {
          removeAllAndPush(context, const SignUpScreen());
        } else if (value is UserDetails) {
          Future.delayed(const Duration(milliseconds: 1)).then((val) {
            Provider.of<UserProvider>(context, listen: false).setUser(value);
            removeAllAndPush(context, const HomeDashboard());
          });
        } else {
          await auth.firebaseAuth.signOut();

          AppCache().doLogout();

          Future.delayed(const Duration(milliseconds: 1), () {
            removeAllAndPush(context, const LogInScreen());
          });
        }
      });
    } else {
      Future.delayed(const Duration(seconds: 2)).then(
        (value) => removeAllAndPush(context, const IntroScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: theme.colorsList01,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
      ).blurred(
          blur: 1,
          blurColor: Colors.transparent,
          overlay: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StrokeText(
                    text: "WelCome",
                    strokeColor: Color(0xff76008d),
                    strokeWidth: 5,
                    textScaler: TextScaler.linear(2),
                    textStyle: TextStyle(
                      fontFamily: "sahuIt",
                      fontSize: 18,
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 5.0),
                          blurRadius: 25,
                          color: Color(0xff76008d),
                        ),
                      ],
                    )),
                RotationTransition(
                  turns: AlwaysStoppedAnimation(0.98),
                  child: Text(
                    "Play Ground",
                    style: TextStyle(
                      fontFamily: "Univers",
                      fontSize: 25,
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 5.0),
                          blurRadius: 25,
                          color: Color(0xffba55d3),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
