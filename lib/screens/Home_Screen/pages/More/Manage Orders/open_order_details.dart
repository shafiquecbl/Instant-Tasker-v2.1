import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/models/getData.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/Inbox/chat_Screen.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/More/Manage%20Orders/Submit%20Order/submit_order.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/widgets/alert_dialog.dart';
import 'package:instant_tasker/widgets/customAppBar.dart';
import 'package:instant_tasker/widgets/navigator.dart';
import 'package:instant_tasker/widgets/time_ago.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/More/Manage%20Orders/Submit%20Review/submit_review.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/Google Maps/google_maps.dart';
import 'package:google_fonts/google_fonts.dart';

class OpenOrderDetails extends StatefulWidget {
  final String docID;
  OpenOrderDetails(this.docID);
  @override
  _OpenOrderDetailsState createState() => _OpenOrderDetailsState();
}

class _OpenOrderDetailsState extends State<OpenOrderDetails> {
  User user = FirebaseAuth.instance.currentUser;
  GetData getData = GetData();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("Order Details"),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser.email)
              .collection('Orders')
              .doc(widget.docID)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            return offerDetails(snapshot.data);
          },
        ),
      ),
    );
  }

  offerDetails(DocumentSnapshot snapshot) {
    return Column(
      children: [
        details(snapshot),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          height: 50,
          color: Colors.blueGrey[200].withOpacity(0.3),
          child: Text(
            'Submitted Work',
            style: GoogleFonts.teko(
                color: Colors.black.withOpacity(0.7),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        submittedWork(snapshot)
      ],
    );
  }

  details(DocumentSnapshot snapshot) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
                radius: 25,
                backgroundColor: hexColor,
                child: snapshot['Client PhotoURL'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: snapshot['Client PhotoURL'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image(
                            image: AssetImage('assets/images/nullUser.png'),
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          'assets/images/nullUser.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      )),
            title: Text(
              snapshot['Client Name'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            subtitle: Text(
              TimeAgo.timeAgoSinceDate(snapshot['Time']),
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.grey[200],
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    snapshot['Description'],
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                ListTile(
                  leading: Icon(Icons.category_outlined),
                  title: Text(
                    'Category : ${snapshot['Category']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ListTile(
                  leading: Icon(Icons.location_pin),
                  title: Text(
                    snapshot['Location'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ListTile(
                  leading: Icon(
                    Icons.attach_money,
                    color: kGreenColor,
                  ),
                  title: Text(
                    'Budget : Rs.${snapshot['Budget']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: kGreenColor,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ListTile(
                  leading: Icon(Icons.timer),
                  title: Text(
                    'Duration : ${snapshot['Duration']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                divider,
                SizedBox(
                  height: 15,
                ),
                snapshot['Location'] == 'Online'
                    ? Container()
                    : SizedBox(
                        height: 40,
                        width: 140,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              primary: kOrangeColor),
                          icon: Icon(Icons.map, color: Colors.white),
                          onPressed: () {
                            _getCurrentLocation(snapshot);
                          },
                          label: Text(
                            'View on Maps',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      primary: Colors.black.withOpacity(0.7)),
                  icon: Icon(Icons.chat),
                  label: Text('Chat with Tasker'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        receiverName: snapshot['Client Name'],
                        receiverEmail: snapshot['Client Email'],
                        receiverPhotoURL: snapshot['Client PhotoURL'],
                      ),
                    ));
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                snapshot['Status'] != "Completed"
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            primary: kPrimaryColor),
                        child: Text(
                          snapshot['Status'] == "Pending"
                              ? "Submit Order"
                              : "Submit Again",
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => SubmitOrder(
                                snapshot.id,
                                snapshot['Client Email'],
                                snapshot['Time'],
                              ),
                            ),
                          );
                        },
                      )
                    : submitReview(snapshot['Client Email']),
                SizedBox(
                  height: 15,
                ),
                snapshot['Status'] == "Revision"
                    ? Center(
                        child: Text(
                        "( In Revision )",
                        style: TextStyle(color: kOrangeColor),
                      ))
                    : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }

  submitReview(userEmail) {
    return FutureBuilder(
      initialData: [],
      future: getData.getUserData(userEmail),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              primary: kOrangeColor),
          child: Text("Submit Review"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                builder: (_) => SubmitReview(
                      userEmail: userEmail,
                    )));
          },
        );
      },
    );
  }

  submittedWork(DocumentSnapshot snapshot) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser.email)
          .collection("Orders")
          .doc(snapshot.id)
          .collection("Submitted Work")
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.data == null)
          return Center(child: Center(child: CircularProgressIndicator()));
        if (snap.data.docs.length == 0)
          return Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(
                child: Text(
              'No Work Yet',
              style: GoogleFonts.teko(
                fontSize: 16,
                color: kTextColor,
                fontWeight: FontWeight.bold,
              ),
            )),
          );
        return ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: snap.data.docs.length,
            itemBuilder: (context, i) {
              return Container(
                  color: kOfferBackColor,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Work : ${snap.data.docs[i]['Description']}"),
                        Text(
                            "Time : ${TimeAgo.timeAgoSinceDate(snap.data.docs[i]['Time'])}"),
                      ],
                    ),
                  ));
            });
      },
    );
  }

  _getCurrentLocation(DocumentSnapshot snapshot) {
    locationDialog(context);
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      Navigator.pop(context);
      rootNavigator(
          context,
          Mapss(
            position: position,
            desLat: snapshot['Latitude'],
            desLng: snapshot['Longitude'],
          ));
    }).catchError((e) {
      print(e);
    });
  }
}
