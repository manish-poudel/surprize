import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:Surprize/Models/Activity.dart';
import 'package:Surprize/Models/Player.dart';
import 'package:Surprize/Models/User.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:Surprize/Resources/StringResources.dart';

class UserProfile{

  /// Get profile from server
  Future<DocumentSnapshot> getProfile(String userId) async {
    return Firestore.instance.collection(FirestoreResources.userCollectionName).document(userId).get();
  }

  /// Update user
  updateProfile(String userId, Player player){
    return Firestore.instance.collection(FirestoreResources.userCollectionName).document(userId).updateData(player.toMap());
  }

  /// Upload file to storage
  StorageUploadTask uploadFileToStorage(File file, String folderOf){
   return FirebaseStorage.instance.ref().child(FirestoreResources.storageProfileFolder).child(folderOf).putFile(file);
  }


  /// Update url to the firestore
   Future<void> addProfileImageToFirestore(String userId, String url){
    return Firestore.instance.collection(FirestoreResources.userCollectionName).document(userId).updateData(({
      FirestoreResources.fieldPlayerProfileURL : url
    }));
  }

  /// Add recent activity
  addActivity(String userId, ActivityType activityType, String reward, DateTime dateTime ) async {
   CollectionReference recentActivityCollectionReference = Firestore.instance.collection(FirestoreResources.collectionActivity).document(userId).collection(FirestoreResources.collectionActivityList);
   QuerySnapshot allRecentActivitySnapshot = await recentActivityCollectionReference.getDocuments();

   int totalDocLength  = allRecentActivitySnapshot.documentChanges.length;

   if(totalDocLength == 5){
    await updateIdAndAdd(Activity("5", activityType, reward, dateTime),recentActivityCollectionReference,allRecentActivitySnapshot);
   }
   else{
     _addActivityToServer(recentActivityCollectionReference,(totalDocLength + 1).toString(),activityType,reward,dateTime);
   }

  }

  /// Add Activity to server
  _addActivityToServer(recentActivityCollectionReference, id, activityType,reward, dateTime){
  recentActivityCollectionReference.document().setData(Activity(id, activityType, reward,dateTime).toMap());
  }


  /// Decrement the id
  updateIdAndAdd(Activity activity2, CollectionReference ref, QuerySnapshot querySnapshot) async {
    /// Decrease all document id
    querySnapshot.documents.forEach((documentSnapshot){
      Activity activity = Activity.fromMap(documentSnapshot.data);

      /// Replace
      if(activity.id == "1"){
        ref.document(documentSnapshot.documentID).updateData(activity2.toMap());
      }

        if(activity.id != "1"){
          String newId = (int.parse(activity.id) - 1).toString();
          ref.document(documentSnapshot.documentID).updateData({FirestoreResources.fieldActivityId: newId
          });
        }
    });
  }

  /// Get recent activity
  getActivity(userId, Function getActivity) {
    Firestore.instance.collection(FirestoreResources.collectionActivity)
        .document(userId).collection(FirestoreResources.collectionActivityList)
        .snapshots()
        .listen((querySnapshot) {
          querySnapshot.documents.forEach((documentSnapshot){
            Activity activity = Activity.fromMap(documentSnapshot.data);
            getActivity(activity);
          });
    });
  }
}