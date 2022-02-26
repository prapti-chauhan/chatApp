class Chat implements Comparable {
  String? message;
  String? sendBy;
  DateTime? ts;
  String? messageId;

  Chat({this.messageId, this.message, this.sendBy, this.ts});

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'sendBy': sendBy,
      'ts': ts,
      'messageId': messageId
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
        message: map['isOnline'],
        sendBy: map['isTyping'],
        ts: map['username'],
        messageId: map['messageId']);
  }

  @override
  int compareTo(other) {
    return ts!.compareTo(other.ts);
  }
}
