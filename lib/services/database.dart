import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_talk/helperfunctions/sharedpref_helper.dart';

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

  createChatRoom(String chatRoomId,Map chatRoomInfoMap)async{
    final snapShot = await FirebaseFirestore.instance
    .collection("chatrooms")
    .doc(chatRoomId)
    .get();
    if(snapShot.exists){
      //chatroom already exist
      return true;
    }else{
      //chatrooom does not exists
      return FirebaseFirestore.instance
      .collection("chatrooms")
      .doc(chatRoomId)
      .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId)async{
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>>getChatRooms()async{
    String myUsername = await SharedPreferenceHelper().getUserName();
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastMessageSendTs",descending: true)
        .where("users",arrayContains: myUsername)
        .snapshots();
  }

  Future<QuerySnapshot> gerUserInfo(String username)async{
    return await FirebaseFirestore.instance.collection("users")
        .where("username",isEqualTo: username)
        .get();
  }

}