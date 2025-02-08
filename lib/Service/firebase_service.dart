// Function to get data from Firebase Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

Stream<List<Map<String, dynamic>>> getDataFromFirestore() {
  return FirebaseFirestore.instance
      .collection('newData')
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => {
    'text1': doc['text1'],
    'text2': doc['text2'],
  })
      .toList());
}