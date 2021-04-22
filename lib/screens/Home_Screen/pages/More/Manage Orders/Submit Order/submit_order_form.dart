import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instant_tasker/components/default_button.dart';
import 'package:instant_tasker/components/form_error.dart';
import 'package:instant_tasker/models/getData.dart';
import 'package:instant_tasker/models/setData.dart';
import 'package:instant_tasker/models/updateData.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/widgets/alert_dialog.dart';
import 'package:instant_tasker/widgets/outline_input_border.dart';
import 'package:instant_tasker/widgets/snack_bar.dart';

class SubmitOrderForm extends StatefulWidget {
  final String docID;
  final String receiverEmail;
  final String time;
  SubmitOrderForm(this.docID, this.receiverEmail, this.time);
  @override
  _SubmitOrderFormState createState() => _SubmitOrderFormState();
}

class _SubmitOrderFormState extends State<SubmitOrderForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  SetData setData = SetData();
  UpdateData updateData = UpdateData();
  String description;

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
    return FutureBuilder(
      future: GetData().getDocumentID(widget.receiverEmail, widget.time),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              getDescriptionFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(20)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: DefaultButton(
                  text: "Submit Order",
                  press: () async {
                    if (_formKey.currentState.validate()) {
                      showLoadingDialog(context);
                      submitOrder(snapshot.data[0]);
                    }
                  },
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
            ],
          ),
        );
      },
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  Container getDescriptionFormField() {
    return Container(
      height: 200,
      child: TextFormField(
        expands: true,
        minLines: null,
        maxLines: null,
        onSaved: (newValue) => description = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: "Please add description");
            description = value;
          } else {}
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: "Please add description");
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Decription",
          hintText: "Add a description to\nyour order",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.description_outlined),
          border: rectangularBorder,
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////
  submitOrder(DocumentSnapshot snapshot) {
    updateData
        .updateOrderStatus(snapshot.id, widget.docID, widget.receiverEmail)
        .then((value) => {
              setData
                  .sumbitOrder(snapshot.id, widget.docID, description,
                      widget.receiverEmail)
                  .then((value) => {
                        Navigator.pop(context),
                        Snack_Bar.show(context, "Order Submitted Successfully"),
                        Navigator.pop(context)
                      })
            });
  }
}
