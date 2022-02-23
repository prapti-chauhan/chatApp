class Chat implements Comparable<DateTime> {
  String? message;
  String? sendBy;
  DateTime? ts;

  Chat({this.message, this.sendBy, this.ts});

  Map<String, dynamic> toMap() {
    return {'message': message, 'sendBy': sendBy, 'ts': ts};
  }

  Chat.fromMap(Map<String, dynamic> map)
      : message = map['isOnline'],
        sendBy = map['isTyping'],
        ts = map['username'];

  @override
  int compareTo(other) {
    return ts!.compareTo(other);
  }
}
