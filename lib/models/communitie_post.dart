class CommunitiePost {
  String? sId;
  String? name;
  String? description;
  String? imageUrl;
  String? createdBy;
  String? createdAt;

  List<Comments>? comments;
  List<String>? likes;

  CommunitiePost(
      {this.sId,
      this.name,
      this.description,
      this.imageUrl,
      this.createdBy,
      this.createdAt,
      this.comments,
      this.likes});

  CommunitiePost.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? "";
    name = json['name'] ?? "";
    description = json['description'] ?? "";
    imageUrl = json['imageUrl'];
    createdBy = json['createdBy'] ?? "";
    createdAt = json['createdAt'] ?? "";

    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    } else {
      comments = <Comments>[];
    }
    if (json['likes'] != null) {
      likes = json['likes'].cast<String>();
    } else {
      likes = <String>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['description'] = description;
    data['imageUrl'] = imageUrl;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;

    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    data['likes'] = likes;
    return data;
  }
}

class Comments {
  String? userId;
  String? commentText;
  String? createdAt;
  String? sId;

  Comments({this.userId, this.commentText, this.createdAt, this.sId});

  Comments.fromJson(Map<String, dynamic> json) {
    userId = json['userId'] ?? "";
    commentText = json['commentText'] ?? "";
    createdAt = json['createdAt'] ?? "";
    sId = json['_id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['commentText'] = commentText;
    data['createdAt'] = createdAt;
    data['_id'] = sId;
    return data;
  }
}
