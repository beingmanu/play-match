import 'package:flutter/material.dart';

import '../main.dart';

class BasicOutLineContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  final double marginh;
  final double marginv;
  final String? image;

  const BasicOutLineContainer({
    super.key,
    this.height,
    this.width,
    this.child,
    this.padding,
    this.color,
    this.marginh = 0,
    this.marginv = 10,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.symmetric(vertical: marginv, horizontal: marginh),
      padding: padding ?? const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color ?? theme.colorBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorBgCard!, width: 1),
        image: image == null
            ? null
            : DecorationImage(fit: BoxFit.cover, image: NetworkImage(image!)),
      ),
      child: child,
    );
  }
}

class BasicFilledContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  final double margin;
  const BasicFilledContainer({
    super.key,
    this.height,
    this.width,
    this.child,
    this.padding,
    this.color,
    this.margin = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: margin),
      padding: padding ?? const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: theme.colorsList01,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorBgCard!, width: 1),
        // boxShadow: [BoxShadow(blurRadius: 10, color: theme.colorCompanion02)],
      ),
      child: child,
    );
  }
}
