import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {

  final String chatWithUsername,name;

  ChatScreen(this.chatWithUsername,this.name);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
    );
  }
}
