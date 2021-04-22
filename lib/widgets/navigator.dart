import 'package:flutter/material.dart';

Future<Navigator> navigator(BuildContext context, Widget page) {
  return Navigator.push(context, MaterialPageRoute(builder: (_) => page));
}

Future<Navigator> rootNavigator(BuildContext context, Widget page) {
  return Navigator.of(context, rootNavigator: true)
      .push(MaterialPageRoute(builder: (_) => page));
}
