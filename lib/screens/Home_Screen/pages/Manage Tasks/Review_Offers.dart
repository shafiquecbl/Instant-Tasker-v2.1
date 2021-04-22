import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/models/deleteData.dart';
import 'package:instant_tasker/models/setData.dart';
import 'package:instant_tasker/screens/Home_Screen/home_screen.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/Inbox/chat_Screen.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/models/getData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/Tasks/widgets/common_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instant_tasker/widgets/alert_dialog.dart';
import 'package:instant_tasker/widgets/customAppBar.dart';
import 'package:instant_tasker/widgets/time_ago.dart';

class ReviewOffers extends StatefulWidget {
  final String docID;
  final String description;
  final String budget;
  final String duration;
  final String category;
  final String location;
  final double latitude;
  final double longitude;
  ReviewOffers(
      {@required this.docID,
      @required this.budget,
      @required this.category,
      @required this.description,
      @required this.duration,
      @required this.location,
      @required this.latitude,
      @required this.longitude});
  @override
  _ReviewOffersState createState() => _ReviewOffersState();
}

class _ReviewOffersState extends State<ReviewOffers> {
  User user = FirebaseAuth.instance.currentUser;
  GetData getData = GetData();
  int indexLength;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("Review Offers"),
      body: FutureBuilder(
        future: getData.getOffers(widget.docID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null)
            return Center(child: CircularProgressIndicator());
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          indexLength = snapshot.data.length;
          if (indexLength == 0)
            return Container(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 100),
              child: Container(
                height: 50,
                color: kPrimaryColor,
                child: Center(
                    child: Text(
                  'No Offers Yet',
                  style: GoogleFonts.teko(
                    fontSize: 16,
                    color: kTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            );
          return ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: indexLength,
              itemBuilder: (context, i) {
                return list(snapshot.data[i]);
              });
        },
      ),
    );
  }

  list(DocumentSnapshot snapshot) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Email'])
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.data == null)
          return Center(child: CircularProgressIndicator());
        return Container(
          color: kOfferBackColor,
          margin: EdgeInsets.all(10),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: kPrimaryColor.withOpacity(0.8),
                    child: snap.data['PhotoURL'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: snap.data['PhotoURL'],
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
                  snapshot['Email'].split('@').first,
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
                  children: [
                    Container(
                      child: Center(
                          child: Column(
                        children: [
                          snap.data['Reviews as Seller'] == 0
                              ? EmptyRatingBar(
                                  rating: 5,
                                )
                              : RatingBar(
                                  rating: snap.data['Rating as Seller'],
                                ),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          Text('(${snap.data['Reviews as Seller']} Reviews)'),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          Text(
                              "Completetion Rate: ${snap.data['Completion Rate']}%"),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          Text(
                            'Duration : ${snapshot['Duration']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: kPrimaryColor,
                            ),
                          ),
                        ],
                      )),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.grey[200],
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            snapshot['Description'],
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Offer Price',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Rs ${snapshot['Budget']}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                        Divider(
                          height: 1,
                          color: Colors.black,
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Payable Amount',
                                  style: TextStyle(
                                      color: greenColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Rs ${snapshot['Budget']}',
                                  style: TextStyle(
                                      color: greenColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Center(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(children: [
                                    Icon(
                                      Icons.email,
                                      color: snap.data['Email status'] ==
                                              'Verified'
                                          ? kOrangeColor.withOpacity(0.9)
                                          : Colors.grey[400],
                                    ),
                                    Text(
                                      "Email",
                                      style: TextStyle(
                                        color: snap.data['Email status'] ==
                                                'Verified'
                                            ? kOrangeColor.withOpacity(0.9)
                                            : Colors.grey[400],
                                      ),
                                    )
                                  ]),
                                  Column(children: [
                                    Icon(
                                      Icons.phone,
                                      color: snap.data['Phone Number status'] ==
                                              'Verified'
                                          ? kOrangeColor.withOpacity(0.9)
                                          : Colors.grey[400],
                                    ),
                                    Text(
                                      "Phone",
                                      style: TextStyle(
                                        color:
                                            snap.data['Phone Number status'] ==
                                                    'Verified'
                                                ? kOrangeColor.withOpacity(0.9)
                                                : Colors.grey[400],
                                      ),
                                    )
                                  ]),
                                  Column(children: [
                                    Icon(
                                      Icons.payment,
                                      color: snap.data['Payment Status'] ==
                                              'Verified'
                                          ? kOrangeColor.withOpacity(0.9)
                                          : Colors.grey[400],
                                    ),
                                    Text(
                                      "Payment",
                                      style: TextStyle(
                                        color: snap.data['Payment Status'] ==
                                                'Verified'
                                            ? kOrangeColor.withOpacity(0.9)
                                            : Colors.grey[400],
                                      ),
                                    )
                                  ]),
                                  Column(children: [
                                    Icon(
                                      Icons.verified_user,
                                      color:
                                          snap.data['CNIC Status'] == 'verified'
                                              ? kOrangeColor.withOpacity(0.9)
                                              : Colors.grey[400],
                                    ),
                                    Text(
                                      "CNIC",
                                      style: TextStyle(
                                        color: snap.data['CNIC Status'] ==
                                                'verified'
                                            ? kOrangeColor.withOpacity(0.9)
                                            : Colors.grey[400],
                                      ),
                                    )
                                  ]),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Container(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                primary: Colors.black.withOpacity(0.7),
                                textStyle: TextStyle(color: Colors.white)),
                            icon: Icon(Icons.chat),
                            label: Text('Chat with Tasker'),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  receiverName: snapshot['Name'],
                                  receiverEmail: snapshot['Email'],
                                  receiverPhotoURL: snap.data['PhotoURL'],
                                ),
                              ));
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                primary: kPrimaryColor,
                                textStyle: TextStyle(color: Colors.white)),
                            child: Text('Accept Offer'),
                            onPressed: () {
                              acceptOffer(context, snapshot);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  acceptOffer(BuildContext context, DocumentSnapshot snapshot) {
    // set up the button
    Widget acceptButton = CupertinoDialogAction(
      child: Text("Yes"),
      onPressed: () {
        Navigator.pop(context);
        showLoadingDialog(context);
        SetData()
            .assignTask(
              context,
              widget.description,
              widget.category,
              widget.duration,
              widget.budget,
              widget.location,
              snapshot['Email'],
              snapshot['PhotoURL'],
              snapshot['Name'],
              widget.latitude,
              widget.longitude,
            )
            .then((value) => deleteUserRequest(widget.docID))
            .then((value) {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => MainScreen()),
              (route) => false);
        });
      },
    );
    Widget cancelButton = CupertinoDialogAction(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(
        "Confirmation",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text("Do you want to accept offer?"),
      actions: [
        cancelButton,
        acceptButton,
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
}
