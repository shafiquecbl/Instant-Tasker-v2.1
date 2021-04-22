import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:instant_tasker/enum/user_state.dart';
import 'package:instant_tasker/models/updateData.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/body1.dart';
import 'package:instant_tasker/widgets/offline.dart';

class MainScreen extends StatefulWidget {
  static String routeName = "/home_scrreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  User user = FirebaseAuth.instance.currentUser;
  String token;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      UpdateData().setUserState(
        userEmail: user.email,
        userState: UserState.Online,
      );
    });
    WidgetsBinding.instance.addObserver(this);
  }

  void getToken() async {
    token = await messaging.getToken();
    print("TOKENNN: $token");
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .update({'token': token});
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String uEmail = user.email != null ? user.email : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        uEmail != null
            ? UpdateData()
                .setUserState(userEmail: uEmail, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        uEmail != null
            ? UpdateData()
                .setUserState(userEmail: uEmail, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        uEmail != null
            ? UpdateData()
                .setUserState(userEmail: uEmail, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        uEmail != null
            ? UpdateData()
                .setUserState(userEmail: uEmail, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    return Scaffold(
      body: OfflineBuilder(
          connectivityBuilder: (BuildContext context,
              ConnectivityResult connectivity, Widget child) {
            final bool connected = connectivity != ConnectivityResult.none;
            return Container(child: connected ? Check() : offline);
          },
          child: Container()),
    );
  }
}
