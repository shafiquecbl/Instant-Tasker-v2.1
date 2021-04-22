import 'package:cloud_firestore/cloud_firestore.dart';

Future deleteUserRequest(docID) async {
  FirebaseFirestore.instance
      .collection("Buyer Requests")
      .doc(docID)
      .collection("Offers")
      .doc()
      .delete();
  FirebaseFirestore.instance.collection("Buyer Requests").doc(docID).delete();
}
