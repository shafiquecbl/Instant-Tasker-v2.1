import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:instant_tasker/components/default_button.dart';
import 'package:instant_tasker/components/form_error.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/widgets/alert_dialog.dart';
import '../../../constants.dart';

class OtpForm extends StatefulWidget {
  final String phoneNo;
  OtpForm({@required this.phoneNo});

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  String verificationCode;
  String smsCode;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => {showLoadingDialog(context), verify()});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.07),
          Center(
            child: SizedBox(
              width: getProportionateScreenWidth(200),
              child: TextFormField(
                maxLength: 6,
                style: TextStyle(
                  fontSize: 24,
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: otpInputDecoration,
                onChanged: (value) async {
                  smsCode = value;
                },
              ),
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 125),
            child: FormError(errors: errors),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
          DefaultButton(
            text: "Verify Code",
            press: () async {
              removeError(error: "Invalid OTP");
              AuthCredential authCreds = PhoneAuthProvider.credential(
                  verificationId: verificationCode, smsCode: smsCode);
              await FirebaseAuth.instance.currentUser
                  .linkWithCredential(authCreds)
                  .then((value) => {
                        FirebaseFirestore.instance
                            .collection('Users')
                            .doc(_auth.currentUser.email)
                            .update({'Phone Number status': "Verified"}),
                        Navigator.maybePop(context)
                      })
                  .catchError((e) {
                addError(error: "Invalid OTP");
              });
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
          GestureDetector(
            onTap: () {
              setState(() {
                showLoadingDialog(context);
                verify();
              });
            },
            child: Text(
              "Resend OTP Code",
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.10),
        ],
      ),
    );
  }

  verify() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNo,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.currentUser
              .linkWithCredential(credential);
          print("Phone Number verified");
        },
        verificationFailed: (FirebaseAuthException error) {
          Navigator.pop(context);
          addError(error: "Code Sending Failed!");
        },
        codeSent: (String verificationId, int resendToken) async {
          Navigator.maybePop(context);
          setState(() {
            verificationCode = verificationId;
          });
        },
        timeout: const Duration(seconds: 120),
        codeAutoRetrievalTimeout: (String verificationId) {
          print(verificationId);
          setState(() {
            verificationCode = verificationId;
          });
        });
  }
}
