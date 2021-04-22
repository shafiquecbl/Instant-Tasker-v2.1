import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/models/setData.dart';
import 'package:instant_tasker/screens/complete_profile/complete_profile_screen.dart';

final auth = FirebaseAuth.instance;
User user = auth.currentUser;
final email = user.email;

class VerifyEmail extends StatefulWidget {
  VerifyEmail({Key key}) : super(key: key);
  static String routeName = "/verify_email";

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  Timer timer;
  String token;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    user = auth.currentUser;
    if (!user.emailVerified) {
      user.sendEmailVerification();
      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
      super.initState();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: CircularProgressIndicator()),
            SizedBox(height: 20),
            Text(
              "Verification link has been sent to: ",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.6)),
            ),
            Text(
              "$email",
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: kPrimaryColor),
            ),
            SizedBox(height: 5),
            Text("( Verify first to continue! )",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: kGreenColor)),
          ],
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    token = await messaging.getToken();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.pushNamed(context, CompleteProfileScreen.routeName);
      SetData().saveNewUser(email, context, token);
    }
  }
}
