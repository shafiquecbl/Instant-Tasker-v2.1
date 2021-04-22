import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Messages {
  User user = FirebaseAuth.instance.currentUser;
  final email = FirebaseAuth.instance.currentUser.email;
  String uid = FirebaseAuth.instance.currentUser.uid.toString();
  String name = FirebaseAuth.instance.currentUser.displayName;
  String dateTime = DateFormat("dd-MM-yyyy h:mma").format(DateTime.now());

  Future addMessage(receiverEmail, senderName, senderPhotoURL, message) async {
    await FirebaseFirestore.instance
        .collection('Messages')
        .doc(email)
        .collection(receiverEmail)
        .add({
      'Name': senderName,
      'Email': email,
      'PhotoURL': senderPhotoURL,
      'Time': dateTime,
      'Message': message,
      'Type': "text",
      'timestamp': FieldValue.serverTimestamp(),
    });

    return await FirebaseFirestore.instance
        .collection('Messages')
        .doc(receiverEmail)
        .collection(email)
        .add({
      'Name': senderName,
      'Email': email,
      'PhotoURL': senderPhotoURL,
      'Time': dateTime,
      'Message': message,
      'Type': "text",
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future addContact(
      receiverEmail, receiverName, receiverPhotoURl, message) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Contacts')
        .doc(receiverEmail)
        .set({
      'Name': receiverName,
      'Email': receiverEmail,
      'PhotoURL': receiverPhotoURl,
      'Last Message': message,
      'Time': dateTime,
      'Status': "read"
    });

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Contacts')
        .doc(email)
        .set({
      'Name': user.displayName,
      'Email': email,
      'PhotoURL': user.photoURL,
      'Last Message': message,
      'Time': dateTime,
      'Status': "unread"
    });
  }

  Future addContactUsMessage(message) async {
    await FirebaseFirestore.instance
        .collection('Messages')
        .doc(email)
        .collection('johncbl2282@gmail.com')
        .add({
      'Email': user.email,
      'Time': dateTime,
      'Message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    return await FirebaseFirestore.instance
        .collection('Messages')
        .doc('johncbl2282@gmail.com')
        .collection(email)
        .add({
      'Name': user.displayName,
      'Email': email,
      'PhotoURL': user.photoURL,
      'Time': dateTime,
      'Message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future addContactToAdmin(message) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Contact US')
        .doc('johncbl2282@gmail.com')
        .set({'Time': dateTime, 'Status': "read"});

    return await FirebaseFirestore.instance
        .collection('Admin')
        .doc('johncbl2282@gmail.com')
        .collection('Contact US')
        .doc(email)
        .set({
      'Name': user.displayName,
      'Email': email,
      'PhotoURL': user.photoURL,
      'Last Message': message,
      'Time': dateTime,
      'Status': "unread"
    });
  }
}
