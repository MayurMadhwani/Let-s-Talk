import 'package:flutter/material.dart';
import 'screens/signin.dart';

void main() {
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
