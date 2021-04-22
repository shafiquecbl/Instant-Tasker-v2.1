import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/widgets/customAppBar.dart';

import 'add_gig_form.dart';

class AddGig extends StatefulWidget {
  @override
  _AddGigState createState() => _AddGigState();
}

class _AddGigState extends State<AddGig> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("Add Gig"),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Text(
                    "Enter Details",
                    style: GoogleFonts.teko(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  AddGigForm()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
