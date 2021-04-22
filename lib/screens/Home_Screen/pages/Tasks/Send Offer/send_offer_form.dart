import 'package:flutter/material.dart';
import 'package:instant_tasker/components/default_button.dart';
import 'package:instant_tasker/components/form_error.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/models/setData.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/models/getData.dart';
import 'package:instant_tasker/widgets/alert_dialog.dart';
import 'package:instant_tasker/widgets/outline_input_border.dart';

class SendOfferForm extends StatefulWidget {
  final String docID;
  final String email;
  SendOfferForm({this.docID, this.email});
  @override
  _SendOfferFormState createState() => _SendOfferFormState();
}

class _SendOfferFormState extends State<SendOfferForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  bool isVisible = false;

  String description;
  String category;
  String duration;
  String budget;
  String location;

  int radioValue = 1;
  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
      if (radioValue == 0)
        isVisible = true;
      else
        isVisible = false;
    });
  }

  static const durations = <String>[
    '1 Day',
    '2 Days',
    '3 Days',
    '4 Days',
    '5 Days',
    '6 Days',
    '7 Days',
    '8 Days',
    '9 Days',
    '10 Days',
    '11 Days',
    '12 Days',
    '13 Days',
    '14 Days',
    '15 Days',
    '16 Days',
    '17 Days',
    '18 Days',
    '19 Days',
    '20 Days',
    '21 Days',
    '22 Days',
    '23 Days',
    '24 Days',
    '25 Days',
    '26 Days',
    '27 Days',
    '28 Days',
    '29 Days',
    '30 Days',
  ];
  final List<DropdownMenuItem<String>> popUpdurations = durations
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

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
      initialData: [],
      future: GetData().getUserProfile(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              getDescriptionFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              getDurationFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              getBudgetFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(30)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: DefaultButton(
                  text: "Send Offer",
                  press: () async {
                    if (_formKey.currentState.validate()) {
                      if (duration == null) {
                        addError(error: 'Select delivery time');
                      } else {
                        removeError(error: 'Select delivery time');
                        showLoadingDialog(context);
                        SetData()
                            .sendOffer(context, widget.docID, description,
                                duration, budget, widget.email)
                            .then((value) => _formKey.currentState.reset());
                      }
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

  DropdownButtonFormField getDurationFormField() {
    return DropdownButtonFormField(
      onSaved: (newValue) {
        duration = newValue;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kdurationNullError);
        }
        duration = value;
      },
      decoration: InputDecoration(
        labelText: "Delivery Time",
        hintText: "Select delivery time",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.view_day_sharp),
        border: rectangularBorder,
      ),
      items: popUpdurations,
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
            removeError(error: kDescriptionNullError);
            description = value;
          } else {}
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: kDescriptionNullError);
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Decription",
          hintText: "Add a description to\nyour offer",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.description_outlined),
          border: rectangularBorder,
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  TextFormField getBudgetFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => budget = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kbudgetNullError);
          budget = value;
        } else {}
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kbudgetNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Offer amount (Rs.)",
        hintText: "Enter Total offer amount (Rs.)",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.attach_money),
        border: rectangularBorder,
      ),
    );
  }
}
