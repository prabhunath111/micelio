import 'package:flutter/material.dart';

class ShowAlert {

  void showAlertDialog(BuildContext context, title, String bodyMsg) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        if(title=='Success'){
          Navigator.pushReplacementNamed(context, '/login');
        }else {}
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title, style: TextStyle(color: (title=='Error!'?Colors.red:Colors.green)),),
      content: Text(bodyMsg),
      actions: [
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