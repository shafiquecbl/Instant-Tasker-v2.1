import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/models/getData.dart';
import 'package:instant_tasker/models/updateData.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/widgets/alert_dialog.dart';
import 'package:instant_tasker/widgets/customAppBar.dart';
import 'package:instant_tasker/components/default_button.dart';
import 'package:instant_tasker/components/form_error.dart';
import 'package:instant_tasker/widgets/outline_input_border.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:instant_tasker/widgets/snack_bar.dart';

class CompleteOrder extends StatefulWidget {
  final String taskID;
  final String orderID;
  final String userEmail;
  CompleteOrder(
      {@required this.taskID,
      @required this.orderID,
      @required this.userEmail});
  @override
  _CompleteOrderState createState() => _CompleteOrderState();
}

class _CompleteOrderState extends State<CompleteOrder> {
  User user = FirebaseAuth.instance.currentUser;
  double saveRating;
  GetData getData = GetData();
  UpdateData updateData = UpdateData();

  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String review;

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar('Complete Order'),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: Future.wait(
              [getData.getActive(), getData.getUserData(widget.userEmail)]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null)
              return Center(child: CircularProgressIndicator());
            if (snapshot.hasData) return reviewForm(snapshot);
            return Container();
          },
        ),
      ),
    );
  }

  reviewForm(AsyncSnapshot<dynamic> snapshot) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Wrap(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    getReviewFormField(),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    ratingText(),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    ratingBar(),
                    SizedBox(height: getProportionateScreenHeight(30)),
                    FormError(errors: errors),
                    SizedBox(height: getProportionateScreenHeight(30)),
                    markAsComplete(snapshot.data[1]),
                    SizedBox(height: getProportionateScreenHeight(30)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  ratingText() {
    return Text(
      "Rating ( Please provide rating )",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  ratingBar() {
    return RatingBar(
      minRating: 1,
      initialRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      ratingWidget: RatingWidget(
        full: Icon(
          Icons.star,
          color: kPrimaryColor,
        ),
        half: Icon(Icons.star_half, color: kPrimaryColor),
        empty: Icon(Icons.star_border_outlined, color: kPrimaryColor),
      ),
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      onRatingUpdate: (rating) {
        saveRating = rating;
      },
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  markAsComplete(DocumentSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: DefaultButton(
        text: "Submit and Complete",
        press: () async {
          if (_formKey.currentState.validate()) {
            if (saveRating == null) {
              addError(error: "Please provide Rating!");
            } else {
              showLoadingDialog(context);
              updateData
                  .completeOrder(
                      widget.orderID,
                      widget.taskID,
                      widget.userEmail,
                      snapshot['Completed Task'],
                      snapshot['Completion Rate'],
                      snapshot['Reviews as Seller'],
                      snapshot['Rating as Seller'],
                      saveRating,
                      snapshot['Total Task'],
                      review)
                  .then((value) => {
                        Navigator.pop(context),
                        Navigator.pop(context),
                        Navigator.pop(context),
                      })
                  .then((value) =>
                      Snack_Bar(message: "Order Marked as Completed!"));
            }
          }
        },
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  Container getReviewFormField() {
    return Container(
      height: 200,
      child: TextFormField(
        expands: true,
        minLines: null,
        maxLines: null,
        onSaved: (newValue) => review = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: "Please add Review");
            review = value;
          } else {}
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: "Please add Review");
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Review",
          hintText: "Share your review about \nservice",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.star_border_outlined),
          border: rectangularBorder,
        ),
      ),
    );
  }
}
