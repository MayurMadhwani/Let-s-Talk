import 'package:cloud_firestore/cloud_firestore.dart';
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
  Stream messageStream;
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

  Widget chatMessageTile(String message,bool sendByMe){
    return Row(
      mainAxisAlignment: sendByMe?MainAxisAlignment.end:MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFF5CE1CC).withOpacity(0.4),
            borderRadius:BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomRight: sendByMe?Radius.circular(0):Radius.circular(24),
              topRight: Radius.circular(24),
              bottomLeft: sendByMe?Radius.circular(24):Radius.circular(0),
            ),
          ),
          padding: EdgeInsets.all(8),
          child: Text(message,style: TextStyle(
                fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget chatMessages(){
    return StreamBuilder(
      stream: messageStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          padding: EdgeInsets.only(bottom: 70,top: 16),
            itemCount: snapshot.data.docs.length,
            reverse: true,
            itemBuilder: (context, index){
              DocumentSnapshot ds = snapshot.data.docs[index];
              return chatMessageTile(ds["message"],myUserName==ds["sendBy"]);
            },) : Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5CE1CC)),
        ));
      },
    );
  }


  getAndSetMessages()async{
    messageStream = await DataBaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

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
            chatMessages(),
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
                      onChanged: (value){
                        addMessage(false);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type a message",
                      ),
                    )),

                    GestureDetector(
                        onTap: (){
                          addMessage(true);
                        },
                        child: Icon(Icons.send)),

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
