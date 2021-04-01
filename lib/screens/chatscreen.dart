import 'package:flutter/material.dart';
import 'package:lets_talk/helperfunctions/sharedpref_helper.dart';
import 'package:lets_talk/services/database.dart';
import 'package:random_string/random_string.dart';

class ChatScreen extends StatefulWidget {

  final String chatWithUsername,name;

  ChatScreen(this.chatWithUsername,this.name);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  String chatRoomId, messageId = "";
  String myName, myProfilePic, myUserName, myEmail;
  TextEditingController messageTextEditingController = TextEditingController();

  getMyInfoFromSharedPreference()async{
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();

    chatRoomId = getChatRoomIdByUsernames(widget.chatWithUsername, myUserName);
  }

  getChatRoomIdByUsernames(String a, String b){
    if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
      return "$b\_$a";
    }else{
      return "$a\_$b";
    }
  }

  addMessage(bool sendClicked){
    if(messageTextEditingController.text!=""){
        String message = messageTextEditingController.text;
        // messageTextEditingController.text =
      var lastMessageTs = DateTime.now();
      Map<String, dynamic> messageInfoMap = {
        "message" : message,
        "sendBy" : myUserName,
        "ts" : lastMessageTs,
        "imageUrl" : myProfilePic,
      };
      //messageId
      if(messageId == ""){
        messageId = randomAlphaNumeric(12);
      }

      DataBaseMethods().addMessage(chatRoomId, messageId, messageInfoMap)
      .then((value){
        Map<String,dynamic> lastMessageInfoMap = {
          "lastMessage" : message,
          "lastMessageSendTs" : lastMessageTs,
          "lastMessageSendBy" : myUserName,
      };

      DataBaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

      if(sendClicked){
        //remove the text in the message i/p field
        messageTextEditingController.text = "";
        //make message id blank
        messageId = "";
      }
      });
    }
  }

  getAndSetMessages()async{}

  doThisOnLaunch()async{
    await getMyInfoFromSharedPreference();
    getAndSetMessages();
  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF5CE1CC).withOpacity(0.3),
                      border: Border.all(
                      color: Color(0xFF5CE1CC),
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 2),
                  child: Row(children: [
                    Expanded(child: TextField(
                      controller: messageTextEditingController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type a message",
                      ),
                    )),
                    Icon(Icons.send),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
