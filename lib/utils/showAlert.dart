import 'package:flutter/material.dart';

class ShowAlert {
  void showAlertDialog(BuildContext context, title, String bodyMsg) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        // Navigator.of(context).pop();
        if(title=='Success'){
          Navigator.pushReplacementNamed(context, '/login');
        }else {
          Navigator.pop(context);
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title, style: TextStyle(color: (title=='Error!'?Colors.red:Colors.green)),),
      content: Text(bodyMsg),
      actions: (title=='Loading...')?[]:[
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}