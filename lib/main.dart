import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/signin.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xFF5CE1CC),
          scaffoldBackgroundColor: Color(0xFFEAFFFF),
          appBarTheme: AppBarTheme(
            elevation: 1,
          ),
      ),
      home: SignIn(),
    );
  }
}
