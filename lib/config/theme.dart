import 'package:flutter/material.dart';

class AppThemeData extends ChangeNotifier {
  bool darkMode = true;
  String fontFamilyPajaro = "pajaro";
  String fontFamilysahuIt = "sahuIt";
  String fontFamilyUnivers = "Univers";

  Color colors01 = const Color(0xff644ccc);
  Color colors02 = const Color(0xff7b68ee);
  Color colors03 = const Color(0xff9370db);
  Color colors04 = const Color(0xffba55d3);
  Color colors05 = const Color(0xffff00ff);

  Color colors06 = const Color(0xff76dbaa);
  Color colors07 = const Color(0xff3a7d9c);
  Color colors08 = const Color(0xff1a076b);
  Color colors09 = const Color(0xff76008d);
  Color colors10 = const Color(0xffa9025f);

  Color colorCompanion = const Color(0xFF0D0A1C);
  Color colorCompanion01 = const Color(0xff3f585f);
  Color colorCompanion02 = const Color(0xff6f9aa1);
  Color colorCompanion03 = const Color(0xffc6d9db);
  Color colorCompanion04 = const Color(0xfff3f8f8);

  Color colorBlack = const Color(0xFF0F1416);
  Color colorWhite = Colors.white;

  Color? colorBackground;
  Color? textColorGray;
  Color? textColorDefault;
  Color? colorBgDialog;
  Color? buttonColor;
  Color? colorBgCard;
  MaterialColor? primarySwatch;
  List<Color> colorsList01 = [];
  List<Color> colorsList02 = [];

  TextStyle? headLine01;
  TextStyle? headLine02;
  TextStyle? subtitle01;
  TextStyle? subtitle02;
  TextStyle? subtitle03;
  TextStyle? title01;
  TextStyle? title02;

  TextStyle? text20Bold;

  changeDarkMode() {
    darkMode = !darkMode;
    //  AppCache().saveDarkMode(darkMode);
    init(darkMode);
  }

  init(bool darkModeinit) {
    darkMode = darkModeinit;
    if (darkModeinit) {
      colorBackground = colorCompanion;
      textColorGray = colorCompanion03;
      textColorDefault = colorWhite;

      colorBgDialog = colorCompanion01;
      buttonColor = colorCompanion02;
      colorBgCard = colorCompanion01;
      primarySwatch = black;
      colorsList01 = [colors01, colors02, colors03, colors04, colors05];
      colorsList02 = [colors06, colors07, colors08, colors09, colors10];
    } else {
      colorBackground = colorCompanion04;
      textColorGray = colorCompanion02;
      textColorDefault = colorBlack;

      colorBgDialog = colorCompanion01;
      buttonColor = colorCompanion;
      colorBgCard = colorWhite;
      primarySwatch = white;
    }

    text20Bold = TextStyle(
        fontFamily: fontFamilyPajaro,
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w600);

    headLine01 = const TextStyle(
      fontFamily: "sahuIt",
      fontSize: 22,
      color: Color(0xff7b68ee),
      // shadows: <Shadow>[
      //   Shadow(
      //       offset: Offset(3.0, 3.0), blurRadius: 25, color: Color(0xAC644A98)),
      // ],
    );
    headLine02 = const TextStyle(
      fontFamily: "sahuIt",
      fontSize: 22,
      color: Colors.white,
      // shadows: <Shadow>[
      //   Shadow(
      //     offset: Offset(1.0, 5.0),
      //     blurRadius: 25,
      //     color: Color(0xff76008d),
      //   ),
      // ],
    );
    title01 = const TextStyle(
      fontFamily: "Univers",
      fontSize: 16,
      color: Colors.white,
      // shadows: <Shadow>[
      //   Shadow(
      //     offset: Offset(1.0, 5.0),
      //     blurRadius: 25,
      //     color: Color(0xff76008d),
      //   ),
      // ],
    );
    title02 = const TextStyle(
      fontFamily: "pajaro",
      fontSize: 18,
      color: Colors.white,
    );
    subtitle01 = const TextStyle(
      fontFamily: "pajaro",
      fontSize: 14,
      color: Colors.white,
      // shadows: <Shadow>[
      //   Shadow(
      //     offset: Offset(1.0, 5.0),
      //     blurRadius: 25,
      //     color: Color(0xff76008d),
      //   ),
      // ],
    );
    subtitle02 = const TextStyle(
      fontFamily: "pajaro",
      fontSize: 16,
      color: Colors.white,
      // shadows: <Shadow>[
      //   Shadow(
      //     offset: Offset(1.0, 5.0),
      //     blurRadius: 25,
      //     color: Color(0xff76008d),
      //   ),
      // ],
    );
    subtitle03 = const TextStyle(
      fontFamily: "pajaro",
      fontSize: 16,
      color: Colors.white60,
    );
    notifyListeners();
  }
}

const MaterialColor white = MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);

const MaterialColor black = MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(0xFF000000),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
