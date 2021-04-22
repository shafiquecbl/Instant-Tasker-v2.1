import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:instant_tasker/models/push_nofitications.dart';
import 'package:instant_tasker/screens/complete_profile/complete_profile_screen.dart';
import 'package:instant_tasker/widgets/snack_bar.dart';
import 'package:intl/intl.dart';

class SetData {
  final User user = FirebaseAuth.instance.currentUser;
  final email = FirebaseAuth.instance.currentUser.email;
  String uid = FirebaseAuth.instance.currentUser.uid.toString();
  String name = FirebaseAuth.instance.currentUser.displayName;
  String dateTime = DateFormat("dd-MM-yyyy h:mma").format(DateTime.now());
  FieldValue fieldValue = FieldValue.serverTimestamp();

  Future saveNewUser(email, context, token) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('Users');
    users
        .doc(email)
        .set({
          'Email': email,
          'Uid': uid,
          'Email status': "Verified",
          'token': token
        })
        .then((value) =>
            Navigator.pushNamed(context, CompleteProfileScreen.routeName))
        .catchError((e) {
          print(e);
        });
  }

///////////////////////////////////////////////////////////////////////////////////////

  Future postTask(context, description, category, duration, budget, location,
      double lat, double lang) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('Buyer Requests');
    users.doc().set(
      {
        'Email': email,
        'Name': name,
        'Time': dateTime,
        'Description': description,
        'Location': location,
        'Budget': budget,
        'Duration': duration,
        'Category': category,
        'PhotoURL': user.photoURL,
        'Latitude': lat,
        'Longitude': lang
      },
    ).then((value) {
      Navigator.pop(context);
      Snack_Bar.show(context, "Task Posted Sussessfully");
    });
  }

////////////////////////////////////////////////////////////////////////////////////

  Future sendOffer(
      context, docID, description, duration, budget, recEmail) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(recEmail)
        .collection('Notifications')
        .add({
      'Photo': 'offer',
      'Title': "You received a new offer from ${user.displayName}.",
      'Time': dateTime,
      'timestamp': fieldValue
    });
    await FirebaseFirestore.instance
        .collection('Buyer Requests')
        .doc(docID)
        .collection('Offers')
        .doc()
        .set(
      {
        'Name': name,
        'Email': email,
        'Time': dateTime,
        'Description': description,
        'Budget': budget,
        'Duration': duration,
        'PhotoURL': user.photoURL,
      },
    );
    FirebaseFirestore.instance
        .collection('Users')
        .doc(recEmail)
        .get()
        .then((snapshot) {
      sendAndRetrieveMessage(
          token: snapshot['token'],
          title: 'New Offer',
          body: 'You received a new offer from ${email.split('@').first}');
    }).then((value) {
      Navigator.pop(context);
      Snack_Bar.show(context, "Offer sent Sussessfully");
    }).catchError((e) {
      Navigator.pop(context);
      Snack_Bar.show(context, e.message);
    });
  }

  Future assignTask(
      context,
      description,
      category,
      duration,
      budget,
      location,
      receiverEmail,
      receiverPhoto,
      receiverName,
      double lat,
      double lang) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Notifications')
        .add({
      'Photo': 'order',
      'Title': "${user.displayName} placed a new order.",
      'Time': dateTime,
      'timestamp': fieldValue
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Orders')
        .add({
      'Client Email': email,
      'Client Name': name,
      'Time': dateTime,
      'Description': description,
      'Location': location,
      'Budget': budget,
      'Duration': duration,
      'Category': category,
      'Client PhotoURL': user.photoURL,
      'Status': "Pending",
      'TOstatus': "Active",
      'Latitude': lat,
      'Longitude': lang,
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection("Assigned Tasks")
        .add({
      'Seller Email': receiverEmail,
      'Seller Name': receiverName,
      'Time': dateTime,
      'Description': description,
      'Location': location,
      'Budget': budget,
      'Duration': duration,
      'Category': category,
      'Seller PhotoURL': receiverPhoto,
      'Status': "Pending",
      'TOstatus': "Active",
    });

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .get()
        .then((snapshot) {
      sendAndRetrieveMessage(
          token: snapshot['token'],
          title: 'New Order',
          body: 'You received a new order from ${email.split('@').first}');
    });
  }

  Future sumbitOrder(receiverDocID, docID, description, receiverEmail) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Notifications')
        .add({
      'Photo': 'submit',
      'Title': "${user.displayName} submitted the order.",
      'Time': dateTime,
      'timestamp': fieldValue
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Assigned Tasks')
        .doc(receiverDocID)
        .collection("Received Work")
        .add({
      'Time': dateTime,
      'Description': description,
      'timestamp': fieldValue,
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection("Orders")
        .doc(docID)
        .collection("Submitted Work")
        .add({
      'Time': dateTime,
      'Description': description,
      'timestamp': fieldValue,
    });
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .get()
        .then((snapshot) {
      sendAndRetrieveMessage(
          token: snapshot['token'],
          title: 'Order Received',
          body: '${email.split('@').first} submitted order');
    });
  }

  Future uploadCNICs(context,
      {@required cnicFS, @required cnicBS, @required userPhoto}) async {
    await FirebaseFirestore.instance.collection('CNIC').doc(email).set({
      'CNIC FS': cnicFS,
      'CNIC BS': cnicBS,
      'User Photo': userPhoto,
    });

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .update({'CNIC Status': "Submitted"}).then((value) => {
              Navigator.pop(context),
              Navigator.pop(context),
              Navigator.pop(context)
            });
  }

  Future addGig(context,
      {@required title,
      @required category,
      @required description,
      @required budget,
      @required address,
      @required gigURL}) async {
    return await FirebaseFirestore.instance.collection('Gigs').add({
      'Email': user.email,
      'Title': title,
      'Category': category,
      'Description': description,
      'Budget': budget,
      'Address': address,
      'gigURL': gigURL,
      'Popularity': 0
    });
  }

  Future updateGig(context,
      {@required title,
      @required category,
      @required description,
      @required budget,
      @required address,
      @required id}) async {
    return await FirebaseFirestore.instance.collection('Gigs').doc(id).update({
      'Email': user.email,
      'Title': title,
      'Category': category,
      'Description': description,
      'Budget': budget,
      'Address': address,
    });
  }
}
