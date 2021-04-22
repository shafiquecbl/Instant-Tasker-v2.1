import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instant_tasker/size_config.dart';

class GigDetails extends StatefulWidget {
  final String gigID;
  GigDetails({@required this.gigID});
  @override
  _GigDetailsState createState() => _GigDetailsState();
}

class _GigDetailsState extends State<GigDetails> {
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
                Image.network(
                  snapshot.data['gigURL'],
                  fit: BoxFit.cover,
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenWidth,
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
                        Text(
                          snapshot.data['Email'].split('@').first,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
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
