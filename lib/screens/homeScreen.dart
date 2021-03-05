import 'package:flutter/material.dart';

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
                colors: [Colors.pink, Colors.blue]
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(150),
                bottomRight: Radius.circular(150)
              )
            ),
          ),
          RaisedButton(
            onPressed: ()=> Navigator.pushNamed(context, '/register'),
            highlightColor: Colors.blue,
            shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.purpleAccent)
              ),
            child: Text("REGISTER", style: TextStyle(color: Colors.blue,),),
          ),
          RaisedButton(
            onPressed: ()=> Navigator.pushNamed(context, '/login'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.purple)
            ),
            child: Text("LOGIN", style: TextStyle(color: Colors.blue),),
          ),
        ],
      ),
    );
  }
}
