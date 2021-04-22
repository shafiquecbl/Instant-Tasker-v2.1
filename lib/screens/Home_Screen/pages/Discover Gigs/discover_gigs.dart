import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/Discover%20Gigs/view_gig.dart';
import 'package:instant_tasker/size_config.dart';

class DiscoverGigs extends StatefulWidget {
  @override
  _DiscoverGigsState createState() => _DiscoverGigsState();
}

class _DiscoverGigsState extends State<DiscoverGigs> {
  String category;
  static const categories = <String>[
    'All',
    'Pickup Delivery',
    'Electrician',
    'Ac Service',
    'Plumber',
    'Cleaning',
    'Graphic Designer',
    'Software Developer',
    'Painter',
    'Handyman',
    'Carpenter',
    'Car Washer',
    'Gardener',
    'Photo Graphers',
    'Moving',
    'Tailor',
    'Beautician',
    'Drivers and Cab',
    'Lock Master',
    'Labor',
    'Domestic help',
    'Event Planner',
    'Cooking Services',
    'Consultant',
    'Digital Marketing',
    'Mechanic',
    'Welder',
    'Tutors/Teachers',
    'Fitness Trainer',
    'Repairing',
    'UI/UX Designer',
    'Video and  Audio Editors',
    'Interior Designer',
    'Architect',
    'Pest Control',
    'Lawyers/Legal Advisors',
  ];

  final List<DropdownMenuItem<String>> popUpcategories = categories
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(
            'Discover',
            style: GoogleFonts.teko(
              color: kTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: hexColor,
        actions: [
          Container(
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Center(
                child: DropdownButton(
                    style: TextStyle(color: kTextColor),
                    underline: Container(color: Colors.transparent),
                    value: category,
                    hint: Text('All'),
                    items: popUpcategories,
                    onChanged: (value) {
                      setState(() {
                        category = value;
                      });
                    }),
              ))
        ],
      ),
      body: StreamBuilder(
        stream: category == 'All' || category == null
            ? FirebaseFirestore.instance
                .collection('Gigs')
                .orderBy('Popularity', descending: true)
                .snapshots()
            : FirebaseFirestore.instance
                .collection('Gigs')
                .orderBy('Popularity', descending: true)
                .where('Category', isEqualTo: category)
                .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.data.docs.length == 0)
            return Center(
              child: Text(
                'No Gig in\nthis category',
                textAlign: TextAlign.center,
                style: GoogleFonts.teko(
                  color: kTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            );
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return gigs(snapshot.data.docs[index]);
              });
        },
      ),
    );
  }

  Widget gigs(DocumentSnapshot snapshot) {
    return GestureDetector(
      onTap: () {
        if (snapshot['Email'] != FirebaseAuth.instance.currentUser.email) {
          FirebaseFirestore.instance
              .collection('Gigs')
              .doc(snapshot.id)
              .get()
              .then((value) {
            FirebaseFirestore.instance
                .collection('Gigs')
                .doc(snapshot.id)
                .update({'Popularity': value['Popularity'] + 1});
          });
        }
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (_) => ViewGig(
                  gigID: snapshot.id,
                )));
      },
      child: Card(
          elevation: 2,
          margin: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/empty.jpg'))),
                    width: 190,
                    height: 150,
                    child: CachedNetworkImage(
                      imageUrl: snapshot['gigURL'],
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot['Email'].split('@').first,
                      style: TextStyle(
                        fontSize: 14.5,
                      ),
                    ),
                    SizedBox(
                        width: SizeConfig.screenWidth * 0.45,
                        height: 95,
                        child: Text(
                          snapshot['Title'],
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        )),
                    SizedBox(
                      width: SizeConfig.screenWidth * 0.45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: Text(
                              'Rs.${snapshot['Budget']}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
