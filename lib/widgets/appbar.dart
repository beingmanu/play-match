import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool? backButton;
  final bool? centerTitle;
  const MyAppbar(
      {super.key, this.title, this.actions, this.backButton, this.centerTitle});
  @override
  Size get preferredSize => Size.fromHeight(title == null ? 50 : 80);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: backButton ?? false,
      centerTitle: centerTitle,
      titleSpacing: 50,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              theme.darkMode ? Brightness.light : Brightness.dark),
      title: title == null
          ? null
          : Text(
              title!,
              style: theme.text20Bold!.copyWith(fontSize: size.width * .05),
            ),
      toolbarHeight: size.width * .2,
      actions: actions ?? [],
    );
  }
}
