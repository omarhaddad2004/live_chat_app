import 'package:flutter/material.dart';

SnackBar Mysnackbar(String message) {
  return SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.black,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: BorderSide(color: Colors.white24),
    ),
    elevation: 6,
    duration: Duration(seconds: 2),
  );
}
