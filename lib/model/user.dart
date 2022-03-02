class Users {
  final String email;
  final String id;
  final String name;
  final String password;
  final String username;
  final bool isOnline;
  final bool isTyping;
  final DateTime lastSeen;

  Users(
      {required this.id,
      required this.email,
      required this.password,
      required this.username,
      required this.name,
      required this.lastSeen,
      required this.isOnline,
      required this.isTyping});

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

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      isTyping: map['isTyping'] as bool,
      username: map['username'] as String,
      lastSeen: map['lastSeen'] as DateTime,
      password: map['password'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      isOnline: map['isOnline'] as bool,
      id: map['id'] as String,
    );
  }
}
