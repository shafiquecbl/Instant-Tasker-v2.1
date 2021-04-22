import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/widgets/customAppBar.dart';
import 'package:instant_tasker/widgets/time_ago.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("Notifications"),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser.email)
              .collection('Notifications')
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (snapshot.data.docs.length == 0)
              return Center(
                child: Text(
                  "No Notifications",
                  style: GoogleFonts.teko(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              );
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return notifyList(snapshot.data.docs[index]);
                },
              ),
            );
          }),
    );
  }

  notifyList(DocumentSnapshot snapshot) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          tileColor: Colors.grey[50],
          leading: CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(0.4),
            child: Image.asset('assets/${snapshot['Photo']}.png'),
          ),
          title: Text(snapshot['Title']),
          subtitle: Text(TimeAgo.timeAgoSinceDate(snapshot['Time'])),
        ),
      ),
    );
  }
}
