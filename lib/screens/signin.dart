import 'package:flutter/material.dart';
import 'package:lets_talk/constants.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: kAppBarText,),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Color(0xffDB4437),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          child: Text("Sign in with Google",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
          ),
        ),
      ),
    );
  }
}
