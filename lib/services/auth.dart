import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lets_talk/helperfunctions/sharedpref_helper.dart';
import 'package:lets_talk/screens/home.dart';
import 'package:lets_talk/services/database.dart';

class AuthMethods{
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser(){
    return auth.currentUser;
  }

  signInWithGoogle(BuildContext context)async{
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken:  googleSignInAuthentication.accessToken,
    );

    UserCredential result = await _firebaseAuth.signInWithCredential(credential);

    User userDetails = result.user;

    if(result!=Null){
      SharedPreferenceHelper().saveUserEmail(userDetails.email);
      SharedPreferenceHelper().saveUserId(userDetails.uid);
      SharedPreferenceHelper().saveUserName(userDetails.email.replaceAll("@gmail.com", ""));
      SharedPreferenceHelper().saveDisplayName(userDetails.displayName);
      SharedPreferenceHelper().saveUserProfileUrl(userDetails.photoURL);

      Map<String, dynamic> userInfoMap = {
        "email": userDetails.email,
        "username": userDetails.email.replaceAll("@gmaail.com", ""),
        "name": userDetails.displayName,
        "imageUrl": userDetails.photoURL,
      };

      DataBaseMethods().addUserInfoToDB(userDetails.uid, userInfoMap).then(
              (value) => {
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context)=> Home()))
              });
    }

  }
}