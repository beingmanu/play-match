import 'dart:convert';

import '../config/api_endpoints.dart';
import '../config/app_cache.dart';
import 'package:http/http.dart' as http;

import '../models/chats_details.dart';
import '../models/user_model.dart';
import '../utils/snackbar.dart';

class UserServices {
  Future<dynamic> updateUserDetails(
      Map<String, dynamic> jsonData, String uid) async {
    try {
      var token = await AppCache().getToken();
      var headers = {
        'authorization': 'bearer $token',
        'Content-Type': 'application/json'
      };
      var fatchurl = Uri.parse("${APIEndPoints.urlUserRouts}/updateUser/$uid");

      var request = http.Request('PUT', fatchurl);
      request.body = json.encode(jsonData);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      final data = await response.stream.bytesToString();
      final jsondata = await jsonDecode(data);

      if (response.statusCode == 200) {
        UserDetails userData = UserDetails.fromJson(jsondata["data"]);
        return userData;
      } else {
        showToast(jsondata["errorMessage"]);
        return null;
      }
    } catch (e) {
      print("=====$e");
      return null;
    }
  }

  Future<List<ChatsDetails>> getAllChats() async {
    List<ChatsDetails> chats = [];
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://tinderliteapi.onrender.com/v1/user/getChats/66d7fe4247d4d89422087ed3'));

    http.StreamedResponse response = await request.send();
    final data = await response.stream.bytesToString();
    final jsondata = jsonDecode(data);
    if (response.statusCode == 200) {
      for (var element in jsondata["data"]) {
        chats.add(ChatsDetails.fromJson(element["latestMessage"]));
      }
      return chats;
    } else {
      print(response.reasonPhrase);
      return [];
    }
  }
}
