import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Toat_mensaje({int color, String mensaje, int graviti}) {
  Fluttertoast.showToast(
    msg: mensaje,
    toastLength: Toast.LENGTH_SHORT,
    gravity: graviti == 1 ? ToastGravity.TOP : ToastGravity.BOTTOM,
    timeInSecForIosWeb: 3,
    backgroundColor: color == 1 ? Colors.red : Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Toat_mensaje_center({int color, String mensaje}) {
  new Future.delayed(new Duration(seconds: 1), () {
    Fluttertoast.showToast(
      msg: mensaje,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 8,
      backgroundColor: color == 1 ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  });
}
