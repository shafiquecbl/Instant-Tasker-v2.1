import 'package:flutter/material.dart';

// ignore: camel_case_types
class Snack_Bar {
  final String message;

  const Snack_Bar({
    @required this.message,
  });

  static show(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      action: SnackBarAction(
        textColor: Color(0xFFFAF2FB),
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }
}
