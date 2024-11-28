class UserDetails {
  String? sId;
  String? fullName;
  String? userName;
  String? email;
  String? phone;
  String? gender;
  String? profileImage;
  bool? deactiveAccount;
  bool? blockByAdmin;
  String? dob;
  String? bio;
  String? userType;
  List<String>? bFFs;
  Scoreboard? scoreboard;
  List<String>? follows;
  List<String>? followers;
  bool? whatsappNotify;
  Interests? interests;
  String? token;
  int? iV;
  List<String>? likeProfile;
  List<String>? recentPlayGames;
  Location? location;

  UserDetails(
      {this.sId,
      this.fullName,
      this.userName,
      this.email,
      this.phone,
      this.gender,
      this.profileImage,
      this.deactiveAccount,
      this.blockByAdmin,
      this.dob,
      this.bio,
      this.userType,
      this.bFFs,
      this.scoreboard,
      this.follows,
      this.followers,
      this.whatsappNotify,
      this.interests,
      this.token,
      this.iV,
      this.likeProfile,
      this.recentPlayGames,
      this.location});

  UserDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['full_name'];
    userName = json['user_name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    profileImage = json['profile_image'];
    deactiveAccount = json['deactiveAccount'];
    blockByAdmin = json['blockByAdmin'];
    dob = json['dob'];
    bio = json['bio'];
    userType = json['userType'];
    bFFs = json['BFFs'].cast<String>();
    scoreboard = json['scoreboard'] != null
        ? Scoreboard.fromJson(json['scoreboard'])
        : null;
    follows = json['follows'].cast<String>();
    followers = json['followers'].cast<String>();
    whatsappNotify = json['whatsappNotify'];
    interests = json['interests'] != null
        ? Interests.fromJson(json['interests'])
        : null;
    token = json['token'];
    iV = json['__v'];
    likeProfile = json['likeProfile'].cast<String>();
    recentPlayGames = json['recentPlayGames'].cast<String>();
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['full_name'] = fullName;
    data['user_name'] = userName;
    data['email'] = email;
    data['phone'] = phone;
    data['gender'] = gender;
    data['profile_image'] = profileImage;
    data['deactiveAccount'] = deactiveAccount;
    data['blockByAdmin'] = blockByAdmin;
    data['dob'] = dob;
    data['bio'] = bio;
    data['userType'] = userType;
    data['BFFs'] = bFFs;
    if (scoreboard != null) {
      data['scoreboard'] = scoreboard!.toJson();
    }
    data['follows'] = follows;
    data['followers'] = followers;
    data['whatsappNotify'] = whatsappNotify;
    if (interests != null) {
      data['interests'] = interests!.toJson();
    }
    data['token'] = token;
    data['__v'] = iV;
    data['likeProfile'] = likeProfile;
    data['recentPlayGames'] = recentPlayGames;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}

class Scoreboard {
  RankLevel? rankLevel;
  int? points;
  int? userProgress;
  int? winRate;
  List<PointsHistory>? pointsHistory;

  Scoreboard(
      {this.rankLevel,
      this.points,
      this.userProgress,
      this.winRate,
      this.pointsHistory});

  Scoreboard.fromJson(Map<String, dynamic> json) {
    rankLevel = json['rank_level'] != null
        ? RankLevel.fromJson(json['rank_level'])
        : null;
    points = json['points'];
    userProgress = json['user_progress'];
    winRate = json['win_rate'];
    if (json['points_history'] != null) {
      pointsHistory = <PointsHistory>[];
      json['points_history'].forEach((v) {
        pointsHistory!.add(PointsHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (rankLevel != null) {
      data['rank_level'] = rankLevel!.toJson();
    }
    data['points'] = points;
    data['user_progress'] = userProgress;
    data['win_rate'] = winRate;
    if (pointsHistory != null) {
      data['points_history'] = pointsHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RankLevel {
  int? rank;
  String? rankTitle;
  List<Achievements>? achievements;

  RankLevel({this.rank, this.rankTitle, this.achievements});

  RankLevel.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    rankTitle = json['rank_title'];
    if (json['achievements'] != null) {
      achievements = <Achievements>[];
      json['achievements'].forEach((v) {
        achievements!.add(Achievements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rank'] = rank;
    data['rank_title'] = rankTitle;
    if (achievements != null) {
      data['achievements'] = achievements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Achievements {
  int? volume;
  String? type;
  String? sId;

  Achievements({this.volume, this.type, this.sId});

  Achievements.fromJson(Map<String, dynamic> json) {
    volume = json['volume'];
    type = json['type'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['volume'] = volume;
    data['type'] = type;
    data['_id'] = sId;
    return data;
  }
}

class PointsHistory {
  int? points;
  String? date;
  String? sId;

  PointsHistory({this.points, this.date, this.sId});

  PointsHistory.fromJson(Map<String, dynamic> json) {
    points = json['points'];
    date = json['date'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['points'] = points;
    data['date'] = date;
    data['_id'] = sId;
    return data;
  }
}

class Interests {
  List<String>? categories;
  List<String>? subcategories;

  Interests({this.categories, this.subcategories});

  Interests.fromJson(Map<String, dynamic> json) {
    categories = json['categories'].cast<String>();
    subcategories = json['subcategories'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categories'] = categories;
    data['subcategories'] = subcategories;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
