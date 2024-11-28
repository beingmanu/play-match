class GameDetails {
  String? sId;
  String? gameId;
  String? gameName;
  List<Meetings>? meetings;

  GameDetails({this.sId, this.gameId, this.gameName, this.meetings});

  GameDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    gameId = json['gameId'];
    gameName = json['gameName'];
    if (json['meetings'] != null) {
      meetings = <Meetings>[];
      json['meetings'].forEach((v) {
        meetings!.add(Meetings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['gameId'] = gameId;
    data['gameName'] = gameName;
    if (meetings != null) {
      data['meetings'] = meetings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meetings {
  String? meetingId;
  List<Participants>? participants;
  String? sId;

  Meetings({this.meetingId, this.participants, this.sId});

  Meetings.fromJson(Map<String, dynamic> json) {
    meetingId = json['meetingId'];
    if (json['participants'] != null) {
      participants = <Participants>[];
      json['participants'].forEach((v) {
        participants!.add(Participants.fromJson(v));
      });
    }
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['meetingId'] = meetingId;
    if (participants != null) {
      data['participants'] = participants!.map((v) => v.toJson()).toList();
    }
    data['_id'] = sId;
    return data;
  }
}

class Participants {
  String? userId;
  String? name;
  String? sId;

  Participants({this.userId, this.name, this.sId});

  Participants.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['name'] = name;
    data['_id'] = sId;
    return data;
  }
}
