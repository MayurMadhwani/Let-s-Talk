import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lets_talk/constants.dart';
import 'package:lets_talk/screens/signin.dart';
import 'package:lets_talk/services/auth.dart';
import 'package:lets_talk/services/database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isSearching = false;
  Stream usersStream;
  TextEditingController searchUsernameEditingController=TextEditingController();

  onSearchBtnClick()async{
    isSearching =true;
    setState(() {});
    usersStream = await DataBaseMethods().getUserByUserName(searchUsernameEditingController.text);
  }

  Widget searchUsersList(){
    return StreamBuilder(
      stream: usersStream,
    builder: (context, snapshot) {
      return ListView.builder(
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, index) {
          DocumentSnapshot ds = snapshot.data.documents[index];
          return Image.network(ds["imgUrl"]);
        },
       );
      },
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: kAppBarText,
        actions: [
          InkWell(
            onTap: (){
              AuthMethods().signOut().then((s){
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context)=>SignIn()
                ));
              });
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                isSearching ? GestureDetector(
                  onTap: (){
                    isSearching =false;
                    searchUsernameEditingController.text="";
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(Icons.arrow_back),
                  ),
                ):Container(),
                Expanded(
                  child: Container(
                    margin:  EdgeInsets.symmetric(vertical: 20),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black87,
                          width: 1.4,
                          style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                              controller: searchUsernameEditingController,
                            decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Username",
                          ),
                        )),
                        GestureDetector(
                            onTap: (){
                              if(searchUsernameEditingController.text!=""){
                                onSearchBtnClick();
                              }
                            },
                            child: Icon(Icons.search)
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
