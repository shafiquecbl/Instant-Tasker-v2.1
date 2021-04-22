import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/More/Gigs/Add%20Gig/add_gig.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/More/Gigs/Edit%20Gig/edit_gig.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/widgets/navigator.dart';
import 'package:instant_tasker/widgets/snack_bar.dart';

import 'gig_details.dart';

class Gigs extends StatefulWidget {
  @override
  _GigsState createState() => _GigsState();
}

class _GigsState extends State<Gigs> {
  User user = FirebaseAuth.instance.currentUser;
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
            'My Gigs',
            style: GoogleFonts.teko(
              color: kTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: hexColor,
        actions: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Gigs')
                .where('Email', isEqualTo: user.email)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.data.docs.length == 3) return Container();
              return IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(builder: (_) => AddGig()));
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Gigs')
            .where('Email', isEqualTo: user.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.data.docs.length == 0)
            return Center(
              child: Text(
                'No Gigs',
                style: GoogleFonts.teko(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
        Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (_) => GigDetails(gigID: snapshot.id)));
      },
      child: Dismissible(
        key: Key(snapshot.id),
        resizeDuration: Duration(milliseconds: 100),
        background: slideRightBackground(),
        secondaryBackground: slideLeftBackground(),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            return await delete(snapshot.id);
          } else {
            return await edit(snapshot.id);
          }
        },
        child: Card(
            elevation: 2,
            margin: EdgeInsets.all(8),
            child: Row(
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
                        placeholder: (context, url) => Image(
                          image: AssetImage('assets/images/empty.jpg'),
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot['Email'].split('@').first,
                        style: TextStyle(
                          fontSize: 14.5,
                        ),
                      ),
                      Container(
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
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  edit(id) {
    return rootNavigator(context, EditGig(id: id));
  }

  delete(id) async {
    await FirebaseFirestore.instance.collection('Gigs').doc(id).delete();
    return Snack_Bar.show(context, 'Gig deleted!');
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
