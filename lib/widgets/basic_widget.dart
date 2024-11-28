import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../main.dart';

Widget myText(String text,
        {TextAlign align = TextAlign.start,
        TextOverflow overflow = TextOverflow.ellipsis,
        TextStyle? style,
        int maxLine = 10,
        double padding = 8.0,
        bool showshadow = true}) =>
    Padding(
      padding: EdgeInsets.all(padding),
      child: Text(
        text,
        textAlign: align,
        style: showshadow
            ? (style ?? theme.title01)
            : (style ?? theme.title01)!.copyWith(shadows: []),
        overflow: overflow,
        softWrap: true,
        maxLines: maxLine,
      ),
    );

Widget circleLoader({
  Colors? color,
  double width = 1.5,
}) {
  return CircularProgressIndicator(
    color: theme.textColorDefault,
    strokeWidth: width,
  );
}

Widget basicSpace({double? height, double? width}) => SizedBox(
      height: height,
      width: width,
    );

Widget basicIcon(IconData? icon,
        {double size = 18,
        Color? color,
        double pad = 8.0,
        Color? shadowColor}) =>
    Padding(
      padding: EdgeInsets.all(pad),
      child: FaIcon(
        icon,
        color: color ?? theme.textColorDefault,
        size: size,
        shadows: shadowColor != null
            ? [
                Shadow(
                    blurRadius: 5,
                    offset: const Offset(0.2, 0.8),
                    color: shadowColor)
              ]
            : null,
      ),
    );

Widget showHDivider({double hmargin = 5}) => Container(
      height: 2,
      margin: EdgeInsets.symmetric(horizontal: hmargin, vertical: 5),
      decoration: BoxDecoration(
          color: theme.textColorGray, borderRadius: BorderRadius.circular(5)),
    );

Widget showVDivider() => Container(
      width: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: theme.textColorGray, borderRadius: BorderRadius.circular(5)),
    );
