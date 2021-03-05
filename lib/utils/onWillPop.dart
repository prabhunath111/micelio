import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OnWillPop {
  DateTime backbuttonpressedTime;

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 1);

    if (backButton) {
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Double Click to exit app",
          backgroundColor: Colors.white,
          textColor: Colors.black);
      return false;
    }
    return true;
  }
}