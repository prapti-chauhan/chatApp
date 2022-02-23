class Users {
  String? email;
  String? id;
  String? name;
  String? password;
  String? username;
  bool? isOnline;
  bool? isTyping;
  DateTime? lastSeen;

  Users(
      {this.id,
      this.email,
      this.password,
      this.username,
      this.name,
      this.lastSeen,
      this.isOnline,
      this.isTyping});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'id': id,
      'name': name,
      'password': password,
      'username': username,
      'lastSeen': lastSeen,
      'isOnline': isOnline,
      'isTyping': isTyping
    };
  }

  Users.fromMap(Map<String, dynamic> map)
      : isOnline = map['isOnline'],
        isTyping = map['isTyping'],
        username = map['username'],
        lastSeen = map['lastSeen'],
        password = map['password'],
        name = map['name'],
        email = map['email'];
}