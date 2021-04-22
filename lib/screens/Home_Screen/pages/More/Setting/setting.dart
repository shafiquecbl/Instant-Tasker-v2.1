import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instant_tasker/enum/user_state.dart';
import 'package:instant_tasker/models/updateData.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/More/Setting/Contact%20Us/contact%20us.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/widgets/alert_dialog.dart';
import 'package:instant_tasker/widgets/customAppBar.dart';
import 'package:instant_tasker/widgets/navigator.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar('Settings'),
      body: ListView(
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(15),
            ),
            onPressed: () async {
              navigator(context, ContactUs());
              return await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.email)
                  .collection('Contact US')
                  .doc('johncbl2282@gmail.com')
                  .update({'Status': "read"});
            },
            child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      'Contact Us',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(user.email)
                          .collection('Contact US')
                          .where('Status', isEqualTo: 'unread')
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Container();
                        if (snapshot.data.docs.length == 0) return Container();
                        return Container(
                          padding: EdgeInsets.all(1),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 13,
                            minHeight: 13,
                          ),
                          child: new Text(
                            '${snapshot.data.docs.length}',
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 6.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 19),
            child: Divider(
              height: 1,
              thickness: 1.5,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(15),
            ),
            onPressed: () {},
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 19),
            child: Divider(
              height: 1,
              thickness: 1.5,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(15),
            ),
            onPressed: () {},
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Terms and Service',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 19),
            child: Divider(
              height: 1,
              thickness: 1.5,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.all(15)),
            onPressed: () {
              showLoadingDialog(context);
              signout(context);
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Signout',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  signout(BuildContext context) async {
    return await UpdateData().signout(
      context,
      userEmail: user.email,
      userState: UserState.Offline,
    );
  }
}
