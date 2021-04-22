import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/models/verify_email.dart';

showLoadingDialog(context) {
  AlertDialog alert = AlertDialog(
    contentPadding: EdgeInsets.fromLTRB(0, 30, 0, 30),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
        ),
        Text("Please Wait...")
      ],
    ),
  );

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

locationDialog(context) {
  AlertDialog alert = AlertDialog(
    contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 20),
    content: Container(
      height: 80,
      child: Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Fetching Location...",
            style: TextStyle(color: kTextColor),
          )
        ],
      ),
    ),
  );

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

verifyEmailDialog(BuildContext context, title, content) {
  // set up the button
  Widget okButton = CupertinoDialogAction(
    child: Text("Verify"),
    onPressed: () {
      Navigator.pushNamed(context, VerifyEmail.routeName);
    },
  );

  // set up the AlertDialog
  CupertinoAlertDialog alert = CupertinoAlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
