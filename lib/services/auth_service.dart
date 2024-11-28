import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;
import '../config/api_endpoints.dart';
import '../config/app_cache.dart';
import '../models/user_model.dart';
import '../utils/snackbar.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;

  Future<List?> firebasSignIN(String verifyID, String code) async {
    try {
      final AuthCredential credential =
          PhoneAuthProvider.credential(verificationId: verifyID, smsCode: code);

      final userCredential =
          await firebaseAuth.signInWithCredential(credential);

      final User user = (userCredential).user!;

      final bool isNewUser =
          userCredential.additionalUserInfo?.isNewUser ?? false;
      return [isNewUser, user];
    } on FirebaseAuthException catch (e) {
      showToast(e.message!);
      return null;
    }
  }

  Future<dynamic> userSignUp(String fullName, String email, String phone,
      String userName, DateTime dob) async {
    var headers = {'Content-Type': 'application/json'};

    var url = Uri.parse('${APIEndPoints.urlUserRouts}/addUser');

    var body = {
      "full_name": fullName,
      "email": email,
      "phone": int.parse(phone),
      "user_name": userName,
      "dob": dob.toIso8601String(),
      "gender": "Male"
    };

    try {
      var request = http.Request('POST', url);

      request.body = json.encode(body);

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final data = await response.stream.bytesToString();
      final jsondata = await jsonDecode(data);
      print(data);
      if (response.statusCode == 200) {
        var token = jsondata["data"]["token"];

        UserDetails userData = UserDetails.fromJson(jsondata["data"]);

        AppCache().doLogin(token);
        return userData;
      } else {
        if (jsondata["errorMessage"] == "User not found") {
          return "NewUser";
        } else if (jsondata["errorMessage"] == "Block by Admin") {
          return null;
        } else {
          showToast(jsondata["errorMessage"]);
          return null;
        }
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> userLogin(String phone) async {
    var headers = {'Content-Type': 'application/json'};

    var url = Uri.parse('${APIEndPoints.urlUserRouts}/login');

    var body = {
      "phone": phone,
    };
    try {
      var request = http.Request("POST", url);

      request.headers.addAll(headers);

      request.body = json.encode(body);

      http.StreamedResponse response = await request.send();

      final data = await response.stream.bytesToString();

      final jsondata = await jsonDecode(data);
      print("=======$data");
      if (response.statusCode == 200) {
        var token = jsondata["data"]["token"];

        UserDetails userData = UserDetails.fromJson(jsondata["data"]);

        AppCache().doLogin(token);
        showToast("Login successfully");
        return userData;
      } else {
        if (jsondata["errorMessage"] == "User not found") {
          return "NewUser";
        } else if (jsondata["errorMessage"] == "Block by Admin") {
          showToast(jsondata["errorMessage"]);
          return null;
        } else {
          showToast(jsondata["errorMessage"]);
          return null;
        }
      }
    } catch (e) {
      showToast("Something went wrong\n${e.toString()}");
      return;
    }
  }

  Future<dynamic> getUserData(String phone) async {
    var token = await AppCache().getToken();
    try {
      var headers = {
        'Content-Type': 'application/json',
        'authorization': 'bearer $token'
      };

      var body = {"phone": phone, "token": token};

      Uri url = Uri.parse('${APIEndPoints.urlUserRouts}/loginUserData');

      var request = http.Request("GET", url);

      request.body = json.encode(body);

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final data = await response.stream.bytesToString();

      final jsondata = await jsonDecode(data);

      if (response.statusCode == 200) {
        token = jsondata["data"]["token"];

        UserDetails userData = UserDetails.fromJson(jsondata["data"]);

        AppCache().doLogin(token!);
        return userData;
      } else {
        if (jsondata["errorMessage"] == "User-not-found") {
          return "NewUser";
        } else if (jsondata["errorMessage"] == "Block-by-Admin") {
          return null;
        } else {
          showToast(jsondata["errorMessage"]);
          return null;
        }
      }
    } catch (e) {
      showToast("Something went wrong\n${e.toString()}");
      return;
    }
  }
}
