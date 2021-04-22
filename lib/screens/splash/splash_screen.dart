import 'package:flutter/material.dart';
import 'package:instant_tasker/screens/splash/components/body.dart';
import 'package:instant_tasker/size_config.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(body: Body());
  }
}
