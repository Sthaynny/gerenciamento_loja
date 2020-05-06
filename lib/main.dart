import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/views/login_screen/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.deepOrangeAccent,
      ),
      home: LoginScreen(),
    );
  }
}
