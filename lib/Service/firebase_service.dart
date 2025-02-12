// Function to get data from Firebase Firestore
import 'package:cloud_firestore/cloud_firestore.dart';


// Function to get data from Firebase Firestore
Stream<QuerySnapshot>getDataFromFirestore() {
  return FirebaseFirestore.instance
      .collection('posts')
      .orderBy('timestamp', descending: true)
      .snapshots();
}



