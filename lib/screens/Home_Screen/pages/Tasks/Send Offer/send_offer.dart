import 'package:flutter/material.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/Tasks/Send%20Offer/send_offer_form.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/widgets/customAppBar.dart';

class SendOffer extends StatefulWidget {
  final String docID;
  final String email;
  SendOffer({this.docID, this.email});
  @override
  _SendOfferState createState() => _SendOfferState();
}

class _SendOfferState extends State<SendOffer> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("Send Offer"),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  SendOfferForm(
                    docID: widget.docID,
                    email: widget.email,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
