import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:instant_tasker/components/default_button.dart';
import 'package:instant_tasker/components/form_error.dart';
import 'package:instant_tasker/constants.dart';
import 'package:instant_tasker/models/setData.dart';
import 'package:instant_tasker/size_config.dart';
import 'package:instant_tasker/widgets/alert_dialog.dart';
import 'package:instant_tasker/widgets/outline_input_border.dart';
import 'package:instant_tasker/widgets/snack_bar.dart';
import 'package:geocoding/geocoding.dart';

class PostTaskForm extends StatefulWidget {
  @override
  _PostTaskFormState createState() => _PostTaskFormState();
}

class _PostTaskFormState extends State<PostTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  Position _currentPosition;
  GeoPoint geopoint;

  bool isVisible = false;

  String description;
  String category;
  String duration;
  String budget;
  String location;
  double lang;
  double lat;

  int radioValue = 1;
  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
      if (radioValue == 0) {
        isVisible = true;
        _getCurrentLocation();
      } else {
        isVisible = false;
        location = null;
      }
    });
  }

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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          getDescriptionFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          getCategoriesFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          getDurationFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          getBudgetFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.pin_drop_outlined),
                Radio(
                  value: 0,
                  groupValue: radioValue,
                  onChanged: handleRadioValueChanged,
                ),
                Text(
                  'Physical',
                  style: new TextStyle(fontSize: 16.0),
                ),
                SizedBox(
                  width: 50,
                ),
                Icon(Icons.online_prediction_outlined),
                Radio(
                  value: 1,
                  groupValue: radioValue,
                  onChanged: handleRadioValueChanged,
                ),
                Text(
                  'Online',
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          if (isVisible == true)
            if (location != null)
              Text(
                location,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Post Task",
            press: () async {
              if (_formKey.currentState.validate()) {
                if (category == null) {
                  addError(error: 'Please select category');
                } else if (duration == null) {
                  addError(error: 'Please select duration');
                } else {
                  showLoadingDialog(context);
                  if (location == null) {
                    location = "Online";
                    lat = 0;
                    lang = 0;
                  }
                  SetData()
                      .postTask(context, description, category, duration,
                          budget, location, lat, lang)
                      .then((value) => {_formKey.currentState.reset()})
                      .catchError((e) {
                    Navigator.pop(context);
                    Snack_Bar.show(context, e.message);
                  });
                }
              }
            },
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
        ],
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
        labelText: "Duration",
        hintText: "Select duration",
        floatingLabelBehavior: FloatingLabelBehavior.always,
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
          hintText: "Enter task description",
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
        labelText: "Budget (Rs.)",
        hintText: "Enter your budget (Rs.)",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.attach_money),
        border: rectangularBorder,
      ),
    );
  }

  _getCurrentLocation() {
    locationDialog(context);
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        lat = _currentPosition.latitude;
        lang = _currentPosition.longitude;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        location =
            "${place.locality}, ${place.administrativeArea}, ${place.country}";
        Navigator.pop(context);
      });
    } catch (e) {
      print(e);
    }
  }
}
