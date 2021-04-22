import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/More/Verification/verification.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/Tasks/Send%20Offer/send_offer.dart';
import 'package:instant_tasker/models/getData.dart';
import 'package:instant_tasker/widgets/alert_dialog.dart';
import 'package:instant_tasker/widgets/navigator.dart';
import 'package:instant_tasker/widgets/time_ago.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/Google Maps/google_maps.dart';
import 'package:instant_tasker/enum/calculate_distance.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  User user = FirebaseAuth.instance.currentUser;
  GetData getData = new GetData();
  int indexLength;
  String cnicCheck;
  String category;
  String location = 'All';
  String myLocation;
  Position _currentPosition;
  double totalDistance;
  static const categories = <String>[
    'All',
    'My Location',
    'Online',
  ];

  final List<DropdownMenuItem<String>> popUpcategories = categories
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  @override
  void initState() {
    super.initState();
    setState(() {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => {_getCurrentLocation()});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(
            'Buyer Requests',
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
              width: MediaQuery.of(context).size.width * 0.35,
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
                        if (category == 'Online') {
                          location = 'Online';
                        }
                        if (category == 'My Location') {
                          location = myLocation;
                        }
                      });
                    }),
              ))
        ],
      ),
      body: StreamBuilder(
        stream: category == 'All' || category == null
            ? FirebaseFirestore.instance
                .collection("Buyer Requests")
                .where("Email",
                    isNotEqualTo: FirebaseAuth.instance.currentUser.email)
                .snapshots()
            : FirebaseFirestore.instance
                .collection("Buyer Requests")
                .where("Location", isEqualTo: location)
                .where("Email",
                    isNotEqualTo: FirebaseAuth.instance.currentUser.email)
                .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          indexLength = snapshot.data.docs.length;
          if (indexLength == 0)
            return Center(
              child: Text(
                "No Buyer Requests",
                style: GoogleFonts.teko(
                  color: kTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          return SizedBox(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: indexLength,
              physics:
                  PageScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              controller: PageController(viewportFraction: 1.0),
              itemBuilder: (context, i) {
                return SingleChildScrollView(
                    child: container(snapshot.data.docs[i], i));
              },
            ),
          );
        },
      ),
    );
  }

  container(QueryDocumentSnapshot snapshot, i) {
    if (_currentPosition != null) {
      if (snapshot['Location'] != 'Online') {
        totalDistance = calculateDistance(
          _currentPosition.latitude,
          _currentPosition.longitude,
          snapshot['Latitude'],
          snapshot['Longitude'],
        );
      }
    }
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.grey[300]),
      ),
      child: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          Container(
            width: 390,
            child: ListTile(
              leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: hexColor,
                  child: snapshot['PhotoURL'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl: snapshot['PhotoURL'],
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
          ),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            child: Padding(
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
                      child: snapshot['Location'] != 'Online'
                          ? GestureDetector(
                              onDoubleTap: () {
                                rootNavigator(
                                    context,
                                    Mapss(
                                      position: _currentPosition,
                                      desLat: snapshot['Latitude'],
                                      desLng: snapshot['Longitude'],
                                    ));
                              },
                              child: ExpansionTile(
                                leading: Icon(Icons.location_pin),
                                title: Text(
                                  snapshot['Location'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                children: [
                                  _currentPosition != null
                                      ? Center(
                                          child: Text(
                                              'Distance: ${totalDistance.toStringAsFixed(2)} KM',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )))
                                      : Container()
                                ],
                              ),
                            )
                          : ListTile(
                              leading: Icon(Icons.location_pin),
                              title: Text(
                                snapshot['Location'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            )),
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
                  FutureBuilder(
                    future: getData.getCNIC(),
                    builder: (BuildContext context, AsyncSnapshot snap) {
                      cnicCheck = snap.data;
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            primary: kPrimaryColor),
                        child: Text('Send Offer'),
                        onPressed: () {
                          if (cnicCheck == "verified") {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (_) => SendOffer(
                                  docID: snapshot.id,
                                  email: snapshot['Email'],
                                ),
                              ),
                            );
                          } else {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (_) => Verifications(),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      "${i + 1}/$indexLength",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _getCurrentLocation() {
    locationDialog(context);
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        myLocation =
            "${place.locality}, ${place.administrativeArea}, ${place.country}";
        Navigator.of(context, rootNavigator: true).pop();
      });
    } catch (e) {
      print(e);
    }
  }
}
