import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastService {

  static void showPositive({
    @required String msg,
    int duration = 1,
  }) async {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: duration,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  static void showNegative({
    @required String msg,
    int duration = 1,
  }) async {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: duration,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }
}