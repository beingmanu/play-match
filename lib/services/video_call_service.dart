import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_endpoints.dart';
import '../config/app_cache.dart';
import '../models/user_model.dart';
import '../utils/snackbar.dart';

class VideoCallService {
  Future<String?> findRoom(String userID, String gameID) async {
    var token = await AppCache().getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'POST', Uri.parse('${APIEndPoints.urlRoomRouts}/addUserToGame'));
    request.body = json.encode({"userId": userID, "gameId": gameID});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final data = await response.stream.bytesToString();
    final jsondata = jsonDecode(data);
    if (response.statusCode == 200) {
      return jsondata["meetingId"];
    } else {
      showToast("find room error ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> getAuthenticate(UserDetails user, String callID) async {
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('1395846c-e842-4f25-8fa3-10830157f915:43f1a2b439c630c7843f'))}';
    var headers = {
      'Authorization': basicAuth,
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('https://api.dyte.io/v2/meetings/$callID/participants'));
    request.body = json.encode({
      "name": user.userName,
      "picture":
          "https://images.unsplash.com/photo-1719968070073-c6e644a25976?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "preset_name": "group_call_participant",
      "custom_participant_id": user.sId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      final data = await response.stream.bytesToString();
      final jsondata = jsonDecode(data);

      return jsondata["data"]["token"];
    } else {
      showToast("authentication error\n${response.reasonPhrase}");
      return null;
    }
  }
}
