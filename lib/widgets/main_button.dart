import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'basic_widget.dart';

class MainButton extends StatefulWidget {
  final bool isLoading;
  final String title;
  final VoidCallback onTap;
  final double? pad;
  final Color? color;
  const MainButton(
      {super.key,
      required this.isLoading,
      required this.title,
      required this.onTap,
      this.pad,
      this.color});

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: widget.pad == null
            ? EdgeInsets.symmetric(horizontal: size.width * .1, vertical: 10)
            : EdgeInsets.symmetric(horizontal: widget.pad!, vertical: 10),
        child: Container(
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: theme.colorsList01,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20)),
        ).blurred(
          colorOpacity: 0.2,
          blur: 1,
          blurColor: const Color(0x91253BDD),
          borderRadius: BorderRadius.circular(20),
          overlay: widget.isLoading
              ? circleLoader()
              : myText(widget.title,
                  style: TextStyle(
                      fontFamily: "pajaro",
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                  padding: 0),
        ),
      ),
    );
  }
}
