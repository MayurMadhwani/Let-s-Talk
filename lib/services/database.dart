import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods{
  Future addUserInfoToDB(String userId, Map<String, dynamic> userInfoMap)async{
    return await FirebaseFirestore.instance.collection("users").doc(userId).set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getUserByUserName(String username) async {
    return FirebaseFirestore.instance.collection("users").where("username",
        isEqualTo: username).snapshots();
  }

  Future addMessage(String chatRoomId,String messageId, Map messageInfoMap)async{
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId).collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(String chatRoomId,Map lastMessageInfoMap){
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }


}