import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/communitie_post.dart';
import '../models/game_details.dart';
import '../models/user_model.dart';

class ApiService {
  Future<List> getHomeData(String userId) async {
    List<GameDetails> games = [];
    List<UserDetails> users = [];
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://tinderliteapi.onrender.com/v1/user/getHomeData/$userId'));

    http.StreamedResponse response = await request.send();
    final data = await response.stream.bytesToString();
    final jsondata = jsonDecode(data);
    if (response.statusCode == 200) {
      for (var element in jsondata["data"]["recentPlays"]) {
        games.add(GameDetails.fromJson(element));
      }
      for (var element in jsondata["data"]["popularProfiles"]) {
        users.add(UserDetails.fromJson(element));
      }

      return [games, users];
    } else {
      print(response.reasonPhrase);
      return [[], []];
    }
  }

  Future<List<UserDetails>> getNeighbourProfiles() async {
    List<UserDetails> users = [];
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://tinderliteapi.onrender.com/v1/user/getNextProfiles'));

    http.StreamedResponse response = await request.send();
    final data = await response.stream.bytesToString();
    final jsondata = jsonDecode(data);
    if (response.statusCode == 200) {
      for (var element in jsondata["data"]) {
        users.add(UserDetails.fromJson(element));
      }
      return users;
    } else {
      print(response.reasonPhrase);
      return users;
    }
  }

  Future<List<CommunitiePost>> getAllCommunitiesPost() async {
    List<CommunitiePost> list = [];
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://tinderliteapi.onrender.com/v1/user/getAllCommunities'));

    http.StreamedResponse response = await request.send();
    final data = await response.stream.bytesToString();
    final jsondata = jsonDecode(data);
    print("====$jsondata");
    if (response.statusCode == 200) {
      for (var element in jsondata["data"]) {
        list.add(CommunitiePost.fromJson(element));
      }
      return list;
    } else {
      print(response.reasonPhrase);
      return list;
    }
  }
}
