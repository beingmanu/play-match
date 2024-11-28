import 'package:flutter/material.dart';

navigateTo(BuildContext context, Widget destination) {
  try {
    Future(() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => destination,
          ));
    });
  } catch (e) {}
}

removeAllAndPush(BuildContext context, Widget destination) {
  try {
    Future(() => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => destination),
          (route) => false,
        ));
  } catch (e) {
    print("Error while navigating : $e");
  }
}

navigateBack(BuildContext context) {
  try {
    Navigator.pop(context);
  } catch (e) {
    print("Error while navigating : $e");
  }
}
