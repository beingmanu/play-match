class ChatsDetails {
  String? sId;
  String? content;
  String? sender;
  String? target;
  String? timestamp;

  ChatsDetails(
      {this.sId, this.content, this.sender, this.target, this.timestamp});

  ChatsDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = json['content'];
    sender = json['sender'];
    target = json['target'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['content'] = content;
    data['sender'] = sender;
    data['target'] = target;
    data['timestamp'] = timestamp;
    return data;
  }
}
