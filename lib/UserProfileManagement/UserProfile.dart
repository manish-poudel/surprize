import 'dart:async';
import 'dart:io';

import 'package:Surprize/Models/DailyQuizChallenge/UserPresence.dart';
import 'package:Surprize/Models/DailyQuizChallenge/enums/UserPresenceState.dart';
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
    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(FirestoreResources.userCollectionName).document(userId).get();
    return documentSnapshot;
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

  // Set user presence
  void setUserPresence(String userId, UserPresenceState userPresenceState){
    Firestore.instance.collection(FirestoreResources.collectionUserPresence)
        .document(userId)
        .setData(UserPresence(userPresenceState, DateTime.now()).toMap());
  }

}