import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreCRUDOperations{
  DocumentReference getDocumentSnapshot(String collection, String docId);
  Stream<DocumentSnapshot> getSnapshotData(String collection, String docId);
  Future<void> updateField(String collection, String docId, Map<String, dynamic> map, bool merge);
  Future<void> createData(String collection, String docId, Map<String, dynamic> map);
}