import 'package:flutter/material.dart';
import 'package:micelio/screens/homeScreen.dart';
import 'package:micelio/screens/login.dart';
import 'package:micelio/screens/map.dart';
import 'package:micelio/screens/register.dart';
import 'package:micelio/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs = await SharedPreferences.getInstance();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Constants.prefs.getBool("loggedIn") == true?MapPage():Home(),
        '/register': (context) => Register(),
        '/login': (context) => Login(),
        '/map': (context) => MapPage()
      },
    ));
}
