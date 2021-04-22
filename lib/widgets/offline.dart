import 'package:flutter/material.dart';

Widget offline = WillPopScope(
    child: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/1_No Connection.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 100,
            left: 30,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              onPressed: () {},
              child: Text("Retry".toUpperCase()),
            ),
          )
        ],
      ),
    ),
    onWillPop: () async => false);
