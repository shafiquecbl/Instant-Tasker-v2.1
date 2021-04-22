import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/size_config.dart';
import 'edit_profile_form.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: hexColor,
        automaticallyImplyLeading: false,
        title: Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              "Edit Profile",
              style: GoogleFonts.teko(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: kTextColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.grey[100],
          )
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Text(
                    "Profile Info",
                    style: GoogleFonts.teko(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: kPrimaryColor),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  EditProfileForm()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
