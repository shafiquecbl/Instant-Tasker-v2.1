import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/Manage%20Tasks/Manage_Tasks.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/More/Manage%20Orders/manage_orders.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/More/Notifications/notifications.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/More/Setting/setting.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/More/Verification/verification.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/More/user_profile/user_profile.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/Tasks/Tasks.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/widgets/navigator.dart';
import 'Gigs/gigs.dart';
import 'Post a Task/post_task.dart';
import 'components/profile_menu.dart';
import 'package:cached_network_image/cached_network_image.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: false,
        backgroundColor: hexColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(
            'More',
            style: GoogleFonts.teko(
              color: kTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          Center(
            child: Stack(
              children: [
                IconButton(
                  onPressed: () {
                    rootNavigator(context, Setting());
                  },
                  icon: Icon(
                    Icons.settings,
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(user.email)
                      .collection('Contact US')
                      .where('Status', isEqualTo: 'unread')
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Container();
                    if (snapshot.data.docs.length == 0) return Container();
                    return Positioned(
                      top: 6,
                      right: 10,
                      child: new Container(
                        padding: EdgeInsets.all(1),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 13,
                          minHeight: 13,
                        ),
                        child: new Text(
                          '${snapshot.data.docs.length}',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 6.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            color: kProfileColor,
            padding: EdgeInsets.only(top: 25, bottom: 60),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: hexColor,
                      child: user.photoURL != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl: user.photoURL,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Image(
                                  image:
                                      AssetImage('assets/images/nullUser.png'),
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
                    FirebaseAuth.instance.currentUser.email,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          'My Peronal Balance: Rs.0',
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 25, top: 10, bottom: 0),
                  child: Text(
                    'General',
                    style: GoogleFonts.teko(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                ProfileMenu(
                  text: "My Profile",
                  icon: "assets/icons/User Icon.svg",
                  press: () => {navigator(context, UserProfile())},
                ),
                ProfileMenu(
                  text: "Notifications",
                  icon: "assets/icons/verified.svg",
                  press: () {
                    navigator(context, Notifications());
                  },
                ),
                ProfileMenu(
                  text: "Buyer Requests",
                  icon: "assets/icons/Search Icon.svg",
                  press: () {
                    navigator(context, Tasks());
                  },
                ),
                ProfileMenu(
                  text: "Gigs",
                  icon: "assets/icons/gig.svg",
                  press: () {
                    navigator(context, Gigs());
                  },
                ),
                Container(
                  padding: EdgeInsets.only(left: 25, top: 10, bottom: 0),
                  child: Text(
                    'Tasks',
                    style: GoogleFonts.teko(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                ProfileMenu(
                  text: "Post a Task",
                  icon: "assets/icons/posttask.svg",
                  press: () => {rootNavigator(context, PostTask())},
                ),
                ProfileMenu(
                  text: "Manage Tasks",
                  icon: "assets/icons/orders.svg",
                  press: () => {navigator(context, ManageTasks())},
                ),
                Container(
                  padding: EdgeInsets.only(left: 25, top: 10, bottom: 0),
                  child: Text(
                    'Orders',
                    style: GoogleFonts.teko(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                ProfileMenu(
                  text: "Manage Orders",
                  icon: "assets/icons/orders.svg",
                  press: () => {navigator(context, ManageOrders())},
                ),
                Container(
                  padding: EdgeInsets.only(left: 25, top: 10, bottom: 0),
                  child: Text(
                    'Verifications',
                    style: GoogleFonts.teko(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                ProfileMenu(
                  text: "Verifications",
                  icon: "assets/icons/verified.svg",
                  press: () => {rootNavigator(context, Verifications())},
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
