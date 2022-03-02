class Chat implements Comparable {
  final String message;
  final String sendBy;
  final DateTime ts;
  final String messageId;

  Chat({required this.messageId, required this.message, required this.sendBy, required this.ts});

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
    return ts.compareTo(other.ts);
  }
}
