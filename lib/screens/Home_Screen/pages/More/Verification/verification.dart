import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/models/getData.dart';
import 'package:instant_tasker/screens/otp/components/otp_form.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/More/Verification/verify_cnic.dart';
import 'package:instant_tasker/widgets/customAppBar.dart';
import '../../../../../constants.dart';

class Verifications extends StatefulWidget {
  @override
  _VerificationsState createState() => _VerificationsState();
}

class _VerificationsState extends State<Verifications> {
  String phoneNo;
  String cnic;
  String email = FirebaseAuth.instance.currentUser.email;
  String phoneNoStatus;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("Verification"),
      body: FutureBuilder(
        future: GetData().getUserProfile(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          phoneNo = snapshot.data['Phone Number'];
          cnic = snapshot.data['CNIC Status'];
          phoneNoStatus = snapshot.data['Phone Number status'];

          return SafeArea(
            child: ListView(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Text(
                      "Verifications help you to increase your chances of getting selected. People will trust you if you have verified badges on your profile.",
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Text(
                      'Verifications are issued when specific requirements are met. A green tick shows thay the verifications is currently active.',
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: getProportionateScreenHeight(15)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'ID Verifications',
                  style: TextStyle(
                      color: greenColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Column(
                children: [
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Icon(Icons.email_outlined, color: kPrimaryColor),
                      title: Text("Email"),
                      subtitle: Text(email),
                      trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            textStyle: TextStyle(color: kWhiteColor),
                          ),
                          child: Text(
                            'Verified',
                          ),
                          onPressed: null),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Icon(Icons.phone, color: kPrimaryColor),
                      title: Text("Phone"),
                      subtitle: Text(phoneNo),
                      trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              textStyle: TextStyle(color: kWhiteColor),
                              primary: kPrimaryColor.withOpacity(0.9)),
                          child: Text(phoneNoStatus == "Not Verified"
                              ? 'Verify'
                              : 'Verified'),
                          onPressed: phoneNoStatus == "Not Verified"
                              ? () => verifyPhoneNo(context)
                              : null),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Icon(Icons.perm_identity_outlined,
                          color: kPrimaryColor),
                      title: Text("CNIC"),
                      subtitle: Text(
                        'Give members a reason to choose you - knowing that your identity is verified with NADRA CNIC',
                        style: TextStyle(fontSize: 11.5),
                      ),
                      trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              textStyle: TextStyle(color: kWhiteColor),
                              primary: kPrimaryColor.withOpacity(0.9)),
                          child: Text(cnic == 'Submitted'
                              ? 'Submitted'
                              : cnic == 'verified'
                                  ? 'Verified'
                                  : 'Verify'),
                          onPressed: cnic == "Submitted"
                              ? null
                              : cnic == "verified"
                                  ? null
                                  : () =>
                                      Navigator.of(context, rootNavigator: true)
                                          .pushNamed(VerifyCNIC.routeName)),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading:
                          Icon(Icons.payment_outlined, color: kPrimaryColor),
                      title: Text("Payment Method"),
                      subtitle: Text(
                        'Make payments with ease by having your payment method verified',
                        style: TextStyle(fontSize: 11.5),
                      ),
                      trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              textStyle: TextStyle(color: kWhiteColor),
                              primary: kPrimaryColor.withOpacity(0.9)),
                          child: Text('Add'),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(VerifyCNIC.routeName);
                          }),
                    ),
                  ),
                ],
              )
            ]),
          );
        },
      ),
    );
  }

  verifyPhoneNo(BuildContext buildContext) {
    return showBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        backgroundColor: Colors.grey[200],
        context: buildContext,
        builder: (buildContext) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  Text(
                    "OTP Verification",
                    style: GoogleFonts.teko(
                      fontSize: getProportionateScreenWidth(28),
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                      height: 1.5,
                    ),
                  ),
                  Text("We sent your code to $phoneNo"),
                  OtpForm(phoneNo: phoneNo),
                ],
              ),
            ),
          );
        });
  }
}
