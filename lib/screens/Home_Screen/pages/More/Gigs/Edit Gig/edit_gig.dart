import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/widgets/customAppBar.dart';
import 'edit_gig_form.dart';

class EditGig extends StatefulWidget {
  final String id;
  EditGig({@required this.id});
  @override
  _EditGigState createState() => _EditGigState();
}

class _EditGigState extends State<EditGig> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("Edit Gig"),
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
                  EditGigForm(id: widget.id)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
