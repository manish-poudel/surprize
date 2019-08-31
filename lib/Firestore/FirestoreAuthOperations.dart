import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

/*
Related to firestore authentication
 */
abstract class FirestoreAuthOperations{
   regUser(email, password);
   loginUser(email, password);
}