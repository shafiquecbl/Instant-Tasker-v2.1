import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instant_tasker/models/getData.dart';
import 'package:instant_tasker/models/updateData.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/widgets/customAppBar.dart';
import 'package:instant_tasker/components/default_button.dart';
import 'package:instant_tasker/components/form_error.dart';
import 'package:instant_tasker/widgets/outline_input_border.dart';

class CancelOrder extends StatefulWidget {
  final String taskID;
  final String orderID;
  final String userEmail;
  CancelOrder(
      {@required this.taskID,
      @required this.orderID,
      @required this.userEmail});
  @override
  _CancelOrderState createState() => _CancelOrderState();
}

class _CancelOrderState extends State<CancelOrder> {
  User user = FirebaseAuth.instance.currentUser;
  GetData getData = GetData();
  UpdateData updateData = UpdateData();

  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String reason;

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
      appBar: customAppBar('Cancel Order'),
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
                    SizedBox(height: getProportionateScreenHeight(10)),
                    FormError(errors: errors),
                    SizedBox(height: getProportionateScreenHeight(30)),
                    cancel(snapshot.data[1]),
                    SizedBox(height: getProportionateScreenHeight(30)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
  ///////////////////////////////////////////////////////////////////////////////

  cancel(DocumentSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: DefaultButton(
        text: "Submit and Cancel",
        press: () async {
          if (_formKey.currentState.validate()) {
            updateData.cancelOrder(context,
                orderID: widget.orderID,
                taskID: widget.taskID,
                receiverEmail: widget.userEmail,
                completedTask: snapshot['Completed Task'],
                cancelledTask: snapshot['Cancelled Task'],
                totalTasks: snapshot['Total Task'],
                reason: reason);
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
        onSaved: (newValue) => reason = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: "Please add Reason");
            reason = value;
          } else {}
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: "Please add Reason");
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Reason",
          hintText: "Why are you cancelling\n order?",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.info_outline),
          border: rectangularBorder,
        ),
      ),
    );
  }
}
