import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/login.dart';
import 'package:twutter/views/register.dart';
import 'views/newpost.dart';
import 'views/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TwutterApp());
}

class TwutterApp extends StatefulWidget {
  @override
  _TwutterAppState createState() => _TwutterAppState();
}

class _TwutterAppState extends State<TwutterApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(title: "Twutter Homepage"),
        // TODO : homepage/following/ownprofile???
        '/post': (context) => PostPage(title: "new record"),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        // TODO : forgot password
        // TODO : profile
        // TODO : own profile
      },
    );
  }
}
