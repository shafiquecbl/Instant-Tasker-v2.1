import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/enum/user_state.dart';
import 'package:instant_tasker/enum/utils.dart';
import 'package:instant_tasker/models/updateData.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/Inbox/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/widgets/customAppBar.dart';
import 'package:instant_tasker/widgets/offline.dart';
import 'package:instant_tasker/widgets/time_ago.dart';

class Inbox extends StatefulWidget {
  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  User user = FirebaseAuth.instance.currentUser;
  final email = FirebaseAuth.instance.currentUser.email;
  int state = 0;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return OfflineBuilder(
        connectivityBuilder: (BuildContext context,
            ConnectivityResult connectivity, Widget child) {
          final bool connected = connectivity != ConnectivityResult.none;
          return Container(child: connected ? body(context) : offline);
        },
        child: Container());
  }

  Widget body(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Inbox"),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(email)
            .collection('Contacts')
            .orderBy("Time", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null)
            return Center(child: CircularProgressIndicator());
          if (snapshot.data.docs.length == 0)
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                child: Text(
                  'No Messages',
                  style: GoogleFonts.teko(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            );
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(email)
                    .collection('Contacts')
                    .snapshots();
              });
            },
            child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return userList(snapshot.data.docs[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget userList(DocumentSnapshot snapshot) {
    return GestureDetector(
      onTap: () => Navigator.of(context, rootNavigator: true)
          .push(
            MaterialPageRoute(
                builder: (_) => ChatScreen(
                      receiverEmail: snapshot['Email'],
                      receiverName: snapshot['Name'],
                      receiverPhotoURL: snapshot['PhotoURL'],
                    )),
          )
          .then((value) => UpdateData().updateMessageStatus(snapshot['Email'])),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).primaryColor,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Stack(children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  child: snapshot['PhotoURL'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: CachedNetworkImage(
                            imageUrl: snapshot['PhotoURL'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image(
                              image: AssetImage('assets/images/nullUser.png'),
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50)),
                          width: 60,
                          height: 60,
                          child: Image.asset(
                            'assets/images/nullUser.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(snapshot['Email'])
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snap) {
                    if (snap.connectionState == ConnectionState.waiting)
                      return Container();
                    state = snap.data['state'];
                    return Positioned(
                      bottom: 0,
                      right: 0,
                      child: new Container(
                        padding: EdgeInsets.all(1),
                        decoration: new BoxDecoration(
                          color: getColor(snap.data['state']),
                          shape: BoxShape.circle,
                          border: Border.all(width: 1.5, color: Colors.white),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                      ),
                    );
                  },
                ),
              ]),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: EdgeInsets.only(
                left: 20,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        snapshot['Name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      snapshot['Status'] == "unread"
                          ? Icon(Icons.mark_email_unread, color: blueColor)
                          : Container()
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 145,
                        // margin: EdgeInsets.only(bottom:15),
                        alignment: Alignment.topLeft,
                        child: Text(
                          snapshot['Last Message'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Text(
                        TimeAgo.timeAgoSinceDate(snapshot['Time']),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getColor(int state) {
    switch (Utils.numToState(state)) {
      case UserState.Offline:
        return Colors.red;
      case UserState.Online:
        return kPrimaryColor;
      default:
        return Colors.orange;
    }
  }
}
