import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:Surprize/Firestore/FirestoreAuthOperations.dart';
import 'package:Surprize/Firestore/FirestoreCRUDOperations.dart';
import 'package:Surprize/Firestore/FirestoreStorageOperations.dart';

class FirestoreOperations extends FirestoreAuthOperations with FirestoreStorage, FirestoreCRUDOperations{
  ///
  /// Reg user with email and password and save user information to the collection
  @override
   Future<FirebaseUser> regUser(email, password) async {
    AuthResult authResult =  await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return authResult.user;
  }

  // Sign in with email and password
  @override
  Future<AuthResult> loginUser(email, password){
    return FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  ///Get Document Snapshot
  @override
  DocumentReference getDocumentSnapshot(
      String collection, String docId) {
    // Return document snapshot.
    CollectionReference userCollectionReference =
    Firestore.instance.collection(collection);
    return userCollectionReference.document(docId);
  }

  /*
  Upload file to firestore storage
   */
  @override
  Future<String> uploadFile(String folderName, String filename, File file) async {
    // TODO: implement uploadFile
    final StorageReference storageReference = FirebaseStorage.instance.ref().child(folderName).child(filename);
    final StorageUploadTask task = storageReference.putFile(file);
    var downloadUrl = await(await task.onComplete).ref.getDownloadURL();
    return downloadUrl;
  }

  /*
  Create new data in firestore
   */
  @override
  Future<void> createData(String collection, String docId, Map<String, dynamic > map) {
    // TODO: implement createData
    return getDocumentSnapshot(collection, docId).setData(map);
  }

  /*
  retrieve data in form of snapshot from firestore
   */
  @override
  Stream<DocumentSnapshot> getSnapshotData(String collection, String docId) {
    // TODO: implement getSnapshotData
    return getDocumentSnapshot(collection, docId).snapshots();
  }

  /*
  Update field in firestore
   */
  @override
  Future<void> updateField(String collection, String docId, Map<String, dynamic > map, bool merge) {
    // TODO: implement updateField
    return getDocumentSnapshot(collection, docId).setData(map, merge: merge);
  }

  @override
  Stream<QuerySnapshot> getMainCollectionSnapshot(String collection) {
    // TODO: implement getCollection
    return Firestore.instance.collection(collection).snapshots();
  }

  @override
  Stream<DocumentSnapshot> getSnapshotStream(String collection, String docId) {
    // TODO: implement getSnapshotStream
    return getDocumentSnapshot(collection, docId).snapshots();
  }

  @override
  CollectionReference getNestedCollectionReference(String collection, String collection2, String docId) {
    // TODO: implement getNestedCollectionReference
    CollectionReference userCollectionReference = Firestore.instance.collection(collection).document(docId).collection(collection2);
    return userCollectionReference;
  }



}
