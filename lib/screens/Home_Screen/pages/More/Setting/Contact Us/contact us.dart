import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/enum/user_state.dart';
import 'package:instant_tasker/enum/utils.dart';
import 'package:instant_tasker/models/messages.dart';
import 'package:instant_tasker/models/push_nofitications.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/widgets/outline_input_border.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  User user = FirebaseAuth.instance.currentUser;
  int state = 0;
  TextEditingController textFieldController = TextEditingController();
  bool isWriting = false;
  final String admin = 'johncbl2282@gmail.com';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
          elevation: 2,
          backgroundColor: hexColor,
          centerTitle: true,
          title: Text(
            'Instant Tasker',
            style: GoogleFonts.teko(
              color: kOrangeColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          _sendMessageArea(),
        ],
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Messages')
          .doc(user.email)
          .collection(admin)
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (snapshot.data.docs.length == 0)
          return ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.80,
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        initText1,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                );
              });
        return ListView.builder(
            reverse: true,
            padding: EdgeInsets.all(20),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return chatMessageItem(snapshot.data.docs[index]);
            });
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: snapshot['Email'] == user.email
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: snapshot['Email'] == user.email
            ? senderLayout(snapshot)
            : receiverLayout(snapshot),
      ),
    );
  }

  Widget senderLayout(DocumentSnapshot snapshot) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.80,
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: getMessage(snapshot),
    );
  }

  getMessage(DocumentSnapshot snapshot) {
    return Text(
      snapshot['Message'],
      style: TextStyle(
        color: snapshot['Email'] == user.email ? Colors.white : Colors.black54,
        fontSize: 16.0,
      ),
    );
  }

  Widget receiverLayout(DocumentSnapshot snapshot) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.80,
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: getMessage(snapshot),
    );
  }

  _sendMessageArea() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    sendMessage() {
      var text = textFieldController.text;
      Messages().addContactUsMessage(text).then((value) {
        Messages().addContactToAdmin(text);
      });
      FirebaseFirestore.instance
          .collection('Admin')
          .doc('johncbl2282@gmail.com')
          .get()
          .then((snapshot) {
        sendAndRetrieveMessage(
            token: snapshot['token'],
            title: 'New Message',
            body:
                'You received a new message from ${user.email.split('@').first}');
      });
      setState(() {
        isWriting = false;
      });
      textFieldController.text = "";
    }

    return Container(
      height: 70,
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              controller: textFieldController,
              style: TextStyle(
                color: greyColor,
              ),
              onChanged: (val) {
                (val.length > 0 && val.trim() != "")
                    ? setWritingTo(true)
                    : setWritingTo(false);
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(
                  color: greyColor,
                ),
                border: outlineBorder,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          isWriting
              ? Container(
                  child: IconButton(
                    icon: Icon(Icons.send),
                    iconSize: 25,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      sendMessage();
                    },
                  ),
                )
              : Container(
                  width: 10,
                )
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////////////////
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

  getText(int state) {
    switch (Utils.numToState(state)) {
      case UserState.Offline:
        return 'Offline';
      case UserState.Online:
        return 'Online';
      default:
        return 'Away';
    }
  }
}
