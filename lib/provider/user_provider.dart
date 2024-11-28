import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  late UserDetails userInformation;
  void setUser(UserDetails userdata) {
    userInformation = userdata;
    notifyListeners();
  }
}
