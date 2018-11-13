import 'package:flutter/material.dart';
import 'package:courier/ui/login/login_page.dart';
import 'ui/home_page.dart';

void main() => runApp(new CourierApp());

class CourierApp extends StatelessWidget {
   final routes = <String, WidgetBuilder>{
    "login-page": (context) => LoginPage(),
    "home-page": (context) => HomePage(),
  };
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
        
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}