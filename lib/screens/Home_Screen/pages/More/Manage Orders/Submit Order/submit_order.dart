import 'package:flutter/material.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/More/Manage%20Orders/Submit%20Order/submit_order_form.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/widgets/customAppBar.dart';

class SubmitOrder extends StatefulWidget {
  final String docID;
  final String receiverEmail;
  final String time;
  SubmitOrder(this.docID, this.receiverEmail, this.time);
  @override
  _SubmitOrderState createState() => _SubmitOrderState();
}

class _SubmitOrderState extends State<SubmitOrder> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("Submit Order"),
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
                  SubmitOrderForm(
                      widget.docID, widget.receiverEmail, widget.time),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
