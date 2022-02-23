class Chat implements Comparable<DateTime>{
  String? message;
  String? sendBy;
  DateTime? ts;

  Chat({this.message,this.sendBy,this.ts});

  Map<String,dynamic> toMap(){
    return{
      'message':message,
      'sendBy': sendBy,
      'ts': ts
    };
  }

  @override
  int compareTo(other) {
    return ts!.compareTo(other);
  }
}
