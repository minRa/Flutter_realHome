
class Message {
  final String content;
  final String idFrom;
  final String idTo;
  final String timestamp;
  final int type;

  Message({
   this.content,
   this.idFrom,
   this.idTo,
   this.timestamp,
   this.type,
     });

  Message.fromData(Map<String, dynamic> data)
      : content = data['content'],
        idFrom = data['idFrom'],
        idTo = data['idTo'],
        timestamp = data['timestamp'],
        type = data['type'];

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'idFrom': idFrom,
      'idTo': idTo,
      'timestamp': timestamp,
      'type':type,
    };
  }
}