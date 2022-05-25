import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String uid, sentBy, message;
  final Timestamp ts;
  String? previousChatID;

  ChatMessage(
      {this.uid = '', required this.sentBy, this.message = '', Timestamp? ts})
      : ts = ts ?? Timestamp.now();

  static ChatMessage fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = snap.data() as Map<String, dynamic>;
    return ChatMessage(
      uid: snap.id,
      sentBy: json['sentBy'] ?? '',
      message: json['message'] ?? '',
      ts: json['ts'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> get json =>
      {'sentBy': sentBy, 'message': message, 'ts': ts};

  static List<ChatMessage> fromQuerySnap(QuerySnapshot snap) {
    try {
      return snap.docs.map(ChatMessage.fromDocumentSnap).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  String get previousMessage {
    return previousChatID!;
  }

  // bool hasNotSeenMessage(String uid) {
  //   return !seenBy.contains(uid);
  // }

  Future updateSeen(String userID) {
    return FirebaseFirestore.instance.collection("chats").doc(uid).update({
      'seenBy': FieldValue.arrayUnion([userID])
    });
  }

  static Stream<List<ChatMessage>> currentChats() => FirebaseFirestore.instance
      .collection('chats')
      .orderBy('ts')
      .snapshots()
      .map(ChatMessage.fromQuerySnap);

  Future updateMessage(String newMessage, bool edited) {
    newMessage = edited ? newMessage + " (edited)" : newMessage;
    return FirebaseFirestore.instance.collection("chats").doc(uid) //edite  d
        .update({'message': newMessage});
  }

  Future deleteMessage() {
    return updateMessage("message deleted", false);
  }
}
