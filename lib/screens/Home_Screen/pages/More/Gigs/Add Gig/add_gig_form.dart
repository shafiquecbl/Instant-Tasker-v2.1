import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instant_tasker/components/custom_surfix_icon.dart';
import 'package:instant_tasker/components/default_button.dart';
import 'package:instant_tasker/components/form_error.dart';
import 'package:instant_tasker/models/setData.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/widgets/alert_dialog.dart';
import 'package:instant_tasker/widgets/outline_input_border.dart';
import 'package:instant_tasker/widgets/snack_bar.dart';

import '../../../../../../constants.dart';

class AddGigForm extends StatefulWidget {
  @override
  _AddGigFormState createState() => _AddGigFormState();
}

class _AddGigFormState extends State<AddGigForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  User user = FirebaseAuth.instance.currentUser;

  String title;
  String address;
  String description;
  String category;
  String budget;
  File gigImage;
  String gigURL;
  String name;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.55,
                child: Text(gigImage != null
                    ? 'Image Selected.${gigImage.path.split('.').last}'
                    : ''),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: greenColor),
                child: Text('Select Image'),
                onPressed: () {
                  pickImage();
                },
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Add Gig",
            press: () async {
              if (category == null) {
                addError(error: "Please select category");
              } else if (category != null) {
                removeError(error: "Please select category");
                if (_formKey.currentState.validate()) {
                  if (gigImage == null) {
                    addError(error: "Please select image");
                  } else if (gigImage != null) {
                    removeError(error: "Please select image");
                    showLoadingDialog(context);
                    upload();
                  }
                }
              }
            },
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////
  TextFormField getTitle() {
    return TextFormField(
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

  pickImage() async {
    // ignore: deprecated_member_use
    // ignore: invalid_use_of_visible_for_testing_member
    PickedFile image = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 40);

    setState(() {
      gigImage = File(image.path);
      name = gigImage.path.split('/').last;
    });
  }

  upload() async {
    final img =
        FirebaseStorage.instance.ref().child('Gigs/${user.email}/$name');
    img.putFile(gigImage).then((value) => getdow(img));
  }

  getdow(Reference img) async {
// ignore: unnecessary_cast
    gigURL = await img.getDownloadURL() as String;
    await sData();
  }

  sData() {
    SetData()
        .addGig(context,
            title: title,
            category: category,
            description: description,
            budget: budget,
            address: address,
            gigURL: gigURL)
        .then((value) {
      Navigator.pop(context);
      _formKey.currentState.reset();
      Snack_Bar.show(context, 'Gig added successfully!');
    }).catchError((e) {
      Navigator.pop(context);
      Snack_Bar.show(
          context, 'Slow Network Connection. Please try again later!');
    });
  }
}
