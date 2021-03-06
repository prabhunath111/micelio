import 'package:flutter/material.dart';
import 'package:micelio/utils/button.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: screenSize.height * 0.7,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF81007F), Color(0xFF4A5BAD)]),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100))),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/car.png'),
                  Text(
                    "~WELCOME~",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.05,
          ),
          RaisedGradientButton(
              color: Colors.white,
              child: Text(
                'REGISTER',
                style: TextStyle(color: Colors.white),
              ),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF4A5BAD),
                  Color(0xFF81007F),
                  Color(0xFF4A5BAD)
                ],
              ),
              onPressed: () => Navigator.pushNamed(context, '/register')),
          SizedBox(
            height: screenSize.height * 0.05,
          ),
          RaisedGradientButton(
              child: Text(
                'LOGIN',
                style: TextStyle(color: Colors.white),
              ),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF81007F),
                  Color(0xFF4A5BAD),
                  Color(0xFF81007F)
                ],
              ),
              onPressed: () => Navigator.pushNamed(context, '/login')),
        ],
      ),
    );
  }
}
