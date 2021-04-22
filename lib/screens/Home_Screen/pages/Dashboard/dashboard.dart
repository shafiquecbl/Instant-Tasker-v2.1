import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:instant_tasker/constants.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int msgCount;
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(
            user.email.split('@').first,
            style: GoogleFonts.teko(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: hexColor,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundColor: hexColor,
                    radius: 17,
                    child: user.photoURL != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: CachedNetworkImage(
                              imageUrl: user.photoURL,
                              width: 35,
                              height: 35,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Image(
                                image: AssetImage('assets/images/nullUser.png'),
                                fit: BoxFit.cover,
                                width: 35,
                                height: 35,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Image.asset(
                              'assets/images/nullUser.png',
                              width: 35,
                              height: 35,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 0,
                  child: new Container(
                    padding: EdgeInsets.all(1),
                    decoration: new BoxDecoration(
                      color: kGreenColor,
                      shape: BoxShape.circle,
                      border: Border.all(width: 1.5, color: Colors.white),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(user.email)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  color: kProfileColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      orderCompletetion(snapshot.data),
                      ratingAsSeller(snapshot.data),
                      ratingAsBuyer(snapshot.data),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
                  child: Text('Details'),
                ),
                details(snapshot.data),
                Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
                  child: Text('Messages'),
                ),
                messages(),
                Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
                  child: Text('Reviews'),
                ),
                reviews(snapshot.data),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget ratingAsSeller(DocumentSnapshot snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10),
          child: CircularPercentIndicator(
            radius: 80.0,
            lineWidth: 2.0,
            percent: snapshot['Rating as Seller'] / 5,
            center: Text(
              '${snapshot['Rating as Seller']}',
              style: TextStyle(color: kWhiteColor),
            ),
            progressColor: snapshot['Rating as Seller'] <= 2.5
                ? Colors.red
                : 2.6 <= snapshot['Rating as Seller'] &&
                        snapshot['Rating as Seller'] <= 3.99
                    ? Colors.orange
                    : kGreenColor,
          ),
        ),
        Center(
          child: Text(
            'Rating as\nSeller',
            textAlign: TextAlign.center,
            style: TextStyle(color: kWhiteColor),
          ),
        )
      ],
    );
  }

  Widget ratingAsBuyer(DocumentSnapshot snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10),
          child: CircularPercentIndicator(
            radius: 80.0,
            lineWidth: 2.0,
            percent: snapshot['Rating as Buyer'] / 5,
            center: Text(
              '${snapshot['Rating as Buyer']}',
              style: TextStyle(color: kWhiteColor),
            ),
            progressColor: snapshot['Rating as Buyer'] <= 2.5
                ? Colors.red
                : 2.6 <= snapshot['Rating as Buyer'] &&
                        snapshot['Rating as Buyer'] <= 3.99
                    ? Colors.orange
                    : kGreenColor,
          ),
        ),
        Center(
          child: Text(
            'Rating as\nBuyer',
            textAlign: TextAlign.center,
            style: TextStyle(color: kWhiteColor),
          ),
        )
      ],
    );
  }

  Widget orderCompletetion(DocumentSnapshot snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10),
          child: CircularPercentIndicator(
            radius: 80.0,
            lineWidth: 2.0,
            percent: snapshot['Completion Rate'] / 100,
            center: Text(
              '${snapshot['Completion Rate'].toStringAsFixed(0)}%',
              style: TextStyle(color: kWhiteColor),
            ),
            progressColor: snapshot['Completion Rate'] <= 50.0
                ? Colors.red
                : 51.0 <= snapshot['Completion Rate'] &&
                        snapshot['Completion Rate'] <= 70.0
                    ? Colors.orange
                    : kGreenColor,
          ),
        ),
        Center(
          child: Text(
            'Order\nCompletetion',
            textAlign: TextAlign.center,
            style: TextStyle(color: kWhiteColor),
          ),
        )
      ],
    );
  }

  Widget details(DocumentSnapshot snapshot) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [asSeller(snapshot), asBuyer(snapshot)],
        ),
      ),
    );
  }

  Widget asSeller(DocumentSnapshot snapshot) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      width: MediaQuery.of(context).size.width / 2.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Active Orders'),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(user.email)
                .collection('Orders')
                .where('TOstatus', isEqualTo: 'Active')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Shimmer.fromColors(
                    baseColor: kTextColor,
                    highlightColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        '0',
                        style: GoogleFonts.teko(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ));
              return Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  '${snapshot.data.docs.length}',
                  style: GoogleFonts.teko(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              );
            },
          ),
          Text('Completed Orders'),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              '${snapshot['Completed Task']}',
              style:
                  GoogleFonts.teko(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Text('Cancelled Order'),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              '${snapshot['Cancelled Task']}',
              style:
                  GoogleFonts.teko(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget asBuyer(DocumentSnapshot snapshot) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      width: MediaQuery.of(context).size.width / 2.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Active Tasks'),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(user.email)
                .collection('Assigned Tasks')
                .where('TOstatus', isEqualTo: 'Active')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Shimmer.fromColors(
                    baseColor: kTextColor,
                    highlightColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        '0',
                        style: GoogleFonts.teko(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ));
              return Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  '${snapshot.data.docs.length}',
                  style: GoogleFonts.teko(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              );
            },
          ),
          Text('Completed Tasks'),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              '${snapshot['Completed Task as Buyer']}',
              style:
                  GoogleFonts.teko(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Text('Total Orders'),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              '${snapshot['Total Task']}',
              style:
                  GoogleFonts.teko(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget messages() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .collection('Contacts')
          .where('Status', isEqualTo: 'unread')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return msgShimmer();
        msgCount = snapshot.data.docs.length;
        return Card(
          elevation: 2,
          child: ListTile(
            title: Text(
              msgCount == 0
                  ? 'No Unread Messages'
                  : 'You have $msgCount Unread Messages',
              style:
                  GoogleFonts.teko(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(msgCount == 0
                ? 'Your response time is great!, keep up the good work'
                : 'Reply to messages to keep up the good work'),
            trailing: Container(
              padding: EdgeInsets.all(1),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey[300]),
              ),
              constraints: BoxConstraints(
                minWidth: 40,
                minHeight: 20,
              ),
              child: Text(
                '$msgCount',
                style: new TextStyle(
                    color: kGreenColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget msgShimmer() {
    return Card(
      elevation: 2,
      child: Shimmer.fromColors(
        baseColor: kTextColor,
        highlightColor: Colors.white,
        child: ListTile(
          title: Text(
            'No Unread Messages',
            style: GoogleFonts.teko(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text('Your response time is great!, keep up the good work'),
          trailing: Container(
            padding: EdgeInsets.all(1),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey[300]),
            ),
            constraints: BoxConstraints(
              minWidth: 40,
              minHeight: 20,
            ),
            child: Text(
              '0',
              style: new TextStyle(
                color: kGreenColor,
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget reviews(DocumentSnapshot snapshot) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20),
              width: MediaQuery.of(context).size.width / 2.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reviews as Seller'),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      '${snapshot['Reviews as Seller']}',
                      style: GoogleFonts.teko(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              width: MediaQuery.of(context).size.width / 2.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reviews as Buyer'),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      '${snapshot['Reviews as Buyer']}',
                      style: GoogleFonts.teko(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
