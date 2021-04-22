import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:instant_tasker/components/custom_surfix_icon.dart';
import 'package:instant_tasker/components/default_button.dart';
import 'package:instant_tasker/components/form_error.dart';
import 'package:instant_tasker/models/setData.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/widgets/alert_dialog.dart';
import 'package:instant_tasker/widgets/outline_input_border.dart';
import 'package:instant_tasker/widgets/snack_bar.dart';

class EditGigForm extends StatefulWidget {
  final String id;
  EditGigForm({@required this.id});
  @override
  _EditGigFormState createState() => _EditGigFormState();
}

class _EditGigFormState extends State<EditGigForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  User user = FirebaseAuth.instance.currentUser;

  String title;
  String address;
  String description;
  String category;
  String budget;

  String storeTitle;
  String storeAddress;
  String storeDescription;
  String storeBudget;

  static const categories = <String>[
    'Pickup Delivery',
    'Electrician',
    'Ac Service',
    'Plumber',
    'Cleaning',
    'Graphic Designer',
    'Software Developer',
    'Painter',
    'Handyman',
    'Carpenter',
    'Car Washer',
    'Gardener',
    'Photo Graphers',
    'Moving',
    'Tailor',
    'Beautician',
    'Drivers and Cab',
    'Lock Master',
    'Labor',
    'Domestic help',
    'Event Planner',
    'Cooking Services',
    'Consultant',
    'Digital Marketing',
    'Mechanic',
    'Welder',
    'Tutors/Teachers',
    'Fitness Trainer',
    'Repairing',
    'UI/UX Designer',
    'Video and  Audio Editors',
    'Interior Designer',
    'Architect',
    'Pest Control',
    'Lawyers/Legal Advisors',
    'Other',
  ];

  final List<DropdownMenuItem<String>> popUpcategories = categories
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
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Gigs')
          .doc(widget.id)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null)
          return Center(child: CircularProgressIndicator());
        storeTitle = snapshot.data['Title'];
        storeDescription = snapshot.data['Description'];
        storeBudget = snapshot.data['Budget'];
        storeAddress = snapshot.data['Address'];
        return Form(
          key: _formKey,
          child: Column(
            children: [
              getCategoriesFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              getTitle(),
              SizedBox(height: getProportionateScreenHeight(30)),
              getDescription(),
              SizedBox(height: getProportionateScreenHeight(30)),
              getBudgetFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              getAddressFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(40)),
              DefaultButton(
                text: "Update Gig",
                press: () async {
                  if (category == null) {
                    addError(error: "Please select category");
                  } else if (category != null) {
                    removeError(error: "Please select category");
                    if (_formKey.currentState.validate()) {
                      if (title == null) {
                        title = storeTitle;
                      }
                      if (description == null) {
                        description = storeDescription;
                      }
                      if (address == null) {
                        address = storeAddress;
                      }
                      if (budget == null) {
                        budget = storeBudget;
                      }
                      showLoadingDialog(context);
                      updateData();
                    }
                  }
                },
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
            ],
          ),
        );
      },
    );
  }

  ///////////////////////////////////////////////////////////////////////////////
  TextFormField getTitle() {
    return TextFormField(
      initialValue: storeTitle,
      onSaved: (newValue) => title = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: 'Please add title');
          title = value;
        } else {}
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: 'Please add title');
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Title",
        hintText: "Enter title",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.title_outlined),
        border: rectangularBorder,
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  Container getAddressFormField() {
    return Container(
      height: 100,
      child: TextFormField(
        initialValue: storeAddress,
        expands: true,
        minLines: null,
        maxLines: null,
        onSaved: (newValue) => address = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kAddressNullError);
            address = value;
          } else {}
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: kAddressNullError);
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Address",
          hintText: "Enter your address",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon:
              CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          border: rectangularBorder,
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  TextFormField getBudgetFormField() {
    return TextFormField(
      initialValue: storeBudget,
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
        labelText: "Budget (Rs.)",
        hintText: "Enter your budget (Rs.)",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.attach_money),
        border: rectangularBorder,
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  Container getDescription() {
    return Container(
      height: 200,
      child: TextFormField(
        initialValue: storeDescription,
        expands: true,
        minLines: null,
        maxLines: null,
        onSaved: (newValue) => description = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: "Please add Description");
            description = value;
          } else {}
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: "Please add Description");
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Description",
          hintText: "Describe your service",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.info_outline),
          border: rectangularBorder,
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  DropdownButtonFormField getCategoriesFormField() {
    return DropdownButtonFormField(
      onSaved: (newValue) {
        category = newValue;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCategoryNullError);
        }
        category = value;
      },
      decoration: InputDecoration(
        labelText: "Category",
        hintText: "Select category",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: rectangularBorder,
      ),
      items: popUpcategories,
    );
  }

  updateData() {
    SetData()
        .updateGig(
      context,
      title: title,
      category: category,
      description: description,
      budget: budget,
      address: address,
      id: widget.id,
    )
        .then((value) {
      Navigator.pop(context);
      _formKey.currentState.reset();
      Snack_Bar.show(context, 'Gig updated successfully!');
    }).catchError((e) {
      Navigator.pop(context);
      Snack_Bar.show(
          context, 'Slow Network Connection. Please try again later!');
    });
  }
}
