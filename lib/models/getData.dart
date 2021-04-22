import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetData {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final email = FirebaseAuth.instance.currentUser.email;
  String uid = FirebaseAuth.instance.currentUser.uid.toString();
  String name = FirebaseAuth.instance.currentUser.displayName;

  Future getUserProfile() async {
    DocumentSnapshot document =
        await firestore.collection('Users').doc(email).get();
    return document;
  }

  Future getUserData(userEmail) async {
    DocumentSnapshot document =
        await firestore.collection('Users').doc(userEmail).get();
    return document;
  }

  Future getPostedTask() async {
    QuerySnapshot snapshot = await firestore
        .collection("Buyer Requests")
        .where("Email", isEqualTo: email)
        .get();
    return snapshot.docs;
  }

  // getActive() and getActiveTask() are same

  Future getActive() async {
    QuerySnapshot snapshot = await firestore
        .collection("Users")
        .doc(email)
        .collection("Assigned Tasks")
        .where('TOstatus', isEqualTo: 'Active')
        .get();
    return snapshot.docs;
  }

  Future getActiveTask(docID) async {
    DocumentSnapshot snapshot = await firestore
        .collection("Users")
        .doc(email)
        .collection("Assigned Tasks")
        .doc(docID)
        .get();
    return snapshot;
  }

  Future getCompletedTask(docID) async {
    DocumentSnapshot snapshot = await firestore
        .collection("Users")
        .doc(email)
        .collection("Assigned Tasks")
        .doc(docID)
        .get();
    return snapshot;
  }

  Future getCancelledTask(docID) async {
    DocumentSnapshot snapshot = await firestore
        .collection("Users")
        .doc(email)
        .collection("Assigned Tasks")
        .doc(docID)
        .get();
    return snapshot;
  }

  Future getTask(docID) async {
    DocumentSnapshot snapshot =
        await firestore.collection("Buyer Requests").doc(docID).get();
    return snapshot;
  }

  Future getActiveOrders() async {
    QuerySnapshot snapshot = await firestore
        .collection("Users")
        .doc(email)
        .collection("Orders")
        .where(
          'TOStatus',
          isEqualTo: "Active",
        )
        .get();
    return snapshot.docs;
  }

  Future getCompletedOrders() async {
    QuerySnapshot snapshot = await firestore
        .collection("Users")
        .doc(email)
        .collection("Orders")
        .where(
          'TOStatus',
          isEqualTo: "Completed",
        )
        .get();
    return snapshot.docs;
  }

  Future<String> getCNIC() async {
    DocumentSnapshot document =
        await firestore.collection('Users').doc(email).get();
    String getCNIC = document['CNIC Status'];
    return getCNIC;
  }

  Future getOffers(docID) async {
    QuerySnapshot snapshot = await firestore
        .collection("Buyer Requests")
        .doc(docID)
        .collection('Offers')
        .get();
    return snapshot.docs;
  }

  Future getOrders(docID) async {
    DocumentSnapshot snapshot = await firestore
        .collection("Users")
        .doc(email)
        .collection('Orders')
        .doc(docID)
        .get();
    return snapshot;
  }

  Future getMessages(receiverEmail) async {
    QuerySnapshot snapshot = await firestore
        .collection('Messages')
        .doc(email)
        .collection(receiverEmail)
        .get();
    return snapshot.docs;
  }

  getDocumentID(receiverEmail, time) async {
    QuerySnapshot snapshot = await firestore
        .collection("Users")
        .doc(receiverEmail)
        .collection("Assigned Tasks")
        .where("Time", isEqualTo: time)
        .get();
    return snapshot.docs;
  }

  getorderDocID(receiverEmail, time) async {
    QuerySnapshot snapshot = await firestore
        .collection("Users")
        .doc(receiverEmail)
        .collection("Orders")
        .where("Time", isEqualTo: time)
        .get();
    return snapshot.docs;
  }
}
