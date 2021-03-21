import 'package:flutter/material.dart';
import 'package:lets_talk/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: kAppBarText,),
    );
  }
}
