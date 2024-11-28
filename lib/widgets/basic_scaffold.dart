import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'appbar.dart';

class BasicScafold extends StatelessWidget {
  final String? title;
  final List<Widget>? action;
  final Widget? body;
  final List<Widget>? bottomBar;
  final bool backbutton;
  final bool centerTitle;
  final Widget? floatButton;
  final String? bgImage;
  const BasicScafold({
    super.key,
    this.title,
    this.action,
    this.body,
    this.bottomBar,
    this.backbutton = false,
    this.centerTitle = false,
    this.floatButton,
    this.bgImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorBackground,
      appBar: MyAppbar(
        title: title,
        actions: action,
        backButton: backbutton,
        centerTitle: centerTitle,
      ),
      floatingActionButton: floatButton,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: bottomBar == null
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: bottomBar!,
            ),
      body: bgImage == null
          ? Padding(
              padding: const EdgeInsets.only(left: 6, right: 6, top: 110),
              child: body)
          : Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                    image: AssetImage(bgImage!),
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                        Colors.black26, BlendMode.colorBurn)),
              ),
            ).blurred(
              blur: 1,
              blurColor: theme.colors03,
              colorOpacity: 0.2,
              alignment: Alignment.center,
              overlay: Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6, top: 110),
                  child: body),
            ),
    );
  }
}
