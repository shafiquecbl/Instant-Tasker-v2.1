import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter/material.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/Discover%20Gigs/discover_gigs.dart';
import 'Dashboard/dashboard.dart';
import 'Inbox/inbox.dart';
import 'Manage Tasks/Manage_Tasks.dart';
import 'More/More.dart';

class Check extends StatefulWidget {
  @override
  _CheckState createState() => _CheckState();
}

class _CheckState extends State<Check> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 2);

  List<Widget> _screens = [
    DiscoverGigs(),
    Inbox(),
    Dashboard(),
    ManageTasks(),
    More(),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems = [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.search),
      title: ("Gigs"),
      activeColorPrimary: kPrimaryColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser.email)
            .collection('Contacts')
            .where('Status', isEqualTo: 'unread')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          int _msgCount = 0;
          if (snapshot.data == null) return Icon(Icons.message_outlined);
          _msgCount = snapshot.data.docs.length;
          if (_msgCount == 0) return Icon(Icons.message_outlined);
          return Stack(
            children: <Widget>[
              new Icon(Icons.message_outlined),
              new Positioned(
                right: 0,
                child: new Container(
                  padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: new Text(
                    '$_msgCount',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          );
        },
      ),
      title: ("Inbox"),
      activeColorPrimary: kPrimaryColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.dashboard),
      title: ("Home"),
      activeColorPrimary: kPrimaryColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.file_copy_outlined),
      title: ("Tasks"),
      activeColorPrimary: kPrimaryColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Stack(
        children: [
          Icon(Icons.more_vert_outlined),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser.email)
                .collection('Contact US')
                .where('Status', isEqualTo: 'unread')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Container();
              if (snapshot.data.docs.length == 0) return Container();
              return Positioned(
                right: 0,
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
      title: ("More"),
      activeColorPrimary: kPrimaryColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _screens,
        items: _navBarsItems,
        confineInSafeArea: true,
        navBarHeight: 65,
        backgroundColor: hexColor,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        popAllScreensOnTapOfSelectedTab: false,
        decoration: NavBarDecoration(
          gradient: bPrimaryGradientColor,
          borderRadius: BorderRadius.circular(15),
          colorBehindNavBar: hexColor,
        ),
        navBarStyle: NavBarStyle.style9,
      ),
    );
  }
}
