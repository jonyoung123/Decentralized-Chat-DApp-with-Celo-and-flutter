class ChatDetailModel {
  ChatDetailModel.fromJson(Map<String, dynamic> json) {
    sender = json['sender'] as String?;
    content = json['content'] as String?;
    timestamp = json['timestamp'] as dynamic;
  }

  ChatDetailModel({
    this.sender,
    this.content,
    this.timestamp,
  });
  String? sender;
  String? content;
  dynamic timestamp;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['sender'] = sender;
    json['content'] = content;
    json['timestamp'] = timestamp;
    return json;
  }
}
