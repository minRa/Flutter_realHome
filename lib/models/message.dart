
class Message {
  final String content;
  final String idFrom;
  final String idTo;
  final String timestamp;
  final String docId;
  final int type;

  Message({
   this.content,
   this.idFrom,
   this.idTo,
   this.timestamp,
   this.type,
   this.docId
     });

  Message.fromData(Map<String, dynamic> data, String docId)
      : content = data['content'],
        idFrom = data['idFrom'],
        idTo = data['idTo'],
        timestamp = data['timestamp'],
        type = data['type'],
        docId = docId;

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