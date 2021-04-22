import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/models/getData.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/Inbox/chat_Screen.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/Manage%20Tasks/Review_Offers.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/Tasks/widgets/common_widgets.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/widgets/customAppBar.dart';
import 'package:instant_tasker/widgets/time_ago.dart';

class OpenOfferDetails extends StatefulWidget {
  final String docID;
  OpenOfferDetails(this.docID);
  @override
  _OpenOfferDetailsState createState() => _OpenOfferDetailsState();
}

class _OpenOfferDetailsState extends State<OpenOfferDetails> {
  User user = FirebaseAuth.instance.currentUser;
  GetData getData = GetData();
  int indexLength;
  String passEmail;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("Task Details"),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: Future.wait([
            FirebaseFirestore.instance
                .collection("Buyer Requests")
                .doc(widget.docID)
                .get(),
            getData.getOffers(widget.docID),
          ]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            indexLength = snapshot.data[1].length;
            return Column(
              children: [
                taskDetails(snapshot.data[0]),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  height: 50,
                  color: Colors.blueGrey[200].withOpacity(0.3),
                  child: Text(
                    'OFFERS',
                    style: GoogleFonts.teko(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                indexLength == 0
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 50, horizontal: 100),
                        child: Center(
                            child: Text(
                          'No Offers Yet',
                          style: GoogleFonts.teko(
                            color: kTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )),
                      )
                    : ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: indexLength,
                        itemBuilder: (context, i) {
                          return getOffers(snapshot.data[1][i]);
                        })
              ],
            );
          },
        ),
      ),
    );
  }

  taskDetails(DocumentSnapshot snapshot) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
                radius: 25,
                backgroundColor: kPrimaryColor.withOpacity(0.8),
                child: user.photoURL != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: user.photoURL,
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
              user.displayName,
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
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.grey[300])),
                  child: ListTile(
                    leading: Icon(Icons.category_outlined),
                    title: Text(
                      'Category : ${snapshot['Category']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.grey[300])),
                  child: ListTile(
                    leading: Icon(Icons.location_pin),
                    title: Text(
                      snapshot['Location'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.grey[300])),
                  child: ListTile(
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
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.grey[300])),
                  child: ListTile(
                    leading: Icon(Icons.timer),
                    title: Text(
                      'Duration : ${snapshot['Duration']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                ElevatedButton(
                  child: Text('Review Offers'),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      primary: kPrimaryColor,
                      textStyle: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (_) => ReviewOffers(
                          docID: widget.docID,
                          budget: snapshot['Budget'],
                          category: snapshot['Category'],
                          description: snapshot['Description'],
                          duration: snapshot['Duration'],
                          location: snapshot['Location'],
                          latitude: snapshot['Latitude'],
                          longitude: snapshot['Longitude'],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getOffers(DocumentSnapshot snap) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(snap['Email'])
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null)
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
                    child: snapshot.data['PhotoURL'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data['PhotoURL'],
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
                  snap['Email'].split('@').first,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                subtitle: Text(
                  TimeAgo.timeAgoSinceDate(snap['Time']),
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
                          snapshot.data['Reviews as Seller'] == 0
                              ? EmptyRatingBar(
                                  rating: 5,
                                )
                              : RatingBar(
                                  rating: snapshot.data['Rating as Seller'],
                                ),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          Text(
                              '(${snapshot.data['Reviews as Seller']} Reviews)'),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          Text(
                              "Completetion Rate: ${snapshot.data['Completion Rate']}%"),
                        ],
                      )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      height: 50,
                      color: kOfferColor,
                      child: Center(
                        child: Text(
                          'Offer : Rs.${snap['Budget']}',
                          style: TextStyle(
                              color: greenColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                        padding: EdgeInsets.only(right: 250),
                        child: Text(
                          "Verifications",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(children: [
                                Icon(
                                  Icons.email,
                                  color: snapshot.data['Email status'] ==
                                          'Verified'
                                      ? kOrangeColor.withOpacity(0.9)
                                      : Colors.grey[400],
                                ),
                                Text(
                                  "Email",
                                  style: TextStyle(
                                    color: snapshot.data['Email status'] ==
                                            'Verified'
                                        ? kOrangeColor.withOpacity(0.9)
                                        : Colors.grey[400],
                                  ),
                                )
                              ]),
                              Column(children: [
                                Icon(
                                  Icons.phone,
                                  color: snapshot.data['Phone Number status'] ==
                                          'Verified'
                                      ? kOrangeColor.withOpacity(0.9)
                                      : Colors.grey[400],
                                ),
                                Text(
                                  "Phone",
                                  style: TextStyle(
                                    color:
                                        snapshot.data['Phone Number status'] ==
                                                'Verified'
                                            ? kOrangeColor.withOpacity(0.9)
                                            : Colors.grey[400],
                                  ),
                                )
                              ]),
                              Column(children: [
                                Icon(
                                  Icons.payment,
                                  color: snapshot.data['Payment Status'] ==
                                          'Verified'
                                      ? kOrangeColor.withOpacity(0.9)
                                      : Colors.grey[400],
                                ),
                                Text(
                                  "Payment",
                                  style: TextStyle(
                                    color: snapshot.data['Payment Status'] ==
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
                                      snapshot.data['CNIC Status'] == 'verified'
                                          ? kOrangeColor.withOpacity(0.9)
                                          : Colors.grey[400],
                                ),
                                Text(
                                  "CNIC",
                                  style: TextStyle(
                                    color: snapshot.data['CNIC Status'] ==
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
                      margin: EdgeInsets.only(left: 160),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            primary: Colors.black.withOpacity(0.7),
                            textStyle: TextStyle(color: Colors.white)),
                        icon: Icon(Icons.chat),
                        label: Text('Chat with Tasker'),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              receiverName: snapshot.data['Name'],
                              receiverEmail: snap['Email'],
                              receiverPhotoURL: snapshot.data['PhotoURL'],
                            ),
                          ));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
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
}
