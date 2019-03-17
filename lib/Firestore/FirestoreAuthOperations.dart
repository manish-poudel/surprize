import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

/*
Related to firestore authentication
 */
abstract class FirestoreAuthOperations{
  Future<FirebaseUser> regUser(email, password);
  Future<FirebaseUser> loginUser(email, password);
}