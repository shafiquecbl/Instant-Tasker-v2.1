import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/Inbox/chat_screen.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../constants.dart';

class ViewGig extends StatefulWidget {
  final String gigID;
  ViewGig({@required this.gigID});
  @override
  _ViewGigState createState() => _ViewGigState();
}

class _ViewGigState extends State<ViewGig> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Gigs')
            .doc(widget.gigID)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: snapshot.data['gigURL'],
                  fit: BoxFit.cover,
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenWidth,
                  placeholder: (context, url) => Image(
                    image: AssetImage('assets/images/empty.jpg'),
                    fit: BoxFit.cover,
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenWidth,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              snapshot.data['Email'].split('@').first,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey),
                            ),
                            snapshot.data['Email'] == user.email
                                ? Container()
                                : SizedBox(
                                    height: 40,
                                    width: 140,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        primary: kOrangeColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                      ),
                                      icon: Icon(Icons.chat_outlined,
                                          color: Colors.white),
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(snapshot.data['Email'])
                                            .get()
                                            .then((value) {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (_) => ChatScreen(
                                                        receiverEmail:
                                                            value['Email'],
                                                        receiverName:
                                                            value['Name'],
                                                        receiverPhotoURL:
                                                            value['PhotoURL'],
                                                      )));
                                        });
                                      },
                                      label: Text(
                                        'Chat',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          snapshot.data['Title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'About this Gig',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          snapshot.data['Description'],
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Divider(
                          color: Colors.grey[400],
                        ),
                        Text(
                          'Budget: Rs.${snapshot.data['Budget']}',
                          style: GoogleFonts.teko(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Divider(
                          color: Colors.grey[400],
                        ),
                        Text(
                          'Category: ${snapshot.data['Category']}',
                          style: GoogleFonts.teko(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Divider(
                          color: Colors.grey[400],
                        ),
                        Text(
                          'Address: ${snapshot.data['Address']}',
                          style: GoogleFonts.teko(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
