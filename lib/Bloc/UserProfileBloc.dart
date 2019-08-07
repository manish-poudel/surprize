import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:surprize/Models/Player.dart';
import 'package:surprize/Models/User.dart';
import 'package:surprize/Resources/FirestoreResources.dart';
import 'package:surprize/Resources/StringResources.dart';

class UserProfileBloc{
  String _userId;
  User _user;
  final _userProfileStateController = StreamController<User>();
  StreamSink<User> get _profile => _userProfileStateController.sink;
  Stream<User> get profile => _userProfileStateController.stream;

  final _userProfileEventController  = StreamController();
  Sink get userProfileEventSink => _userProfileStateController.sink;

  UserProfileBloc(this._userId){
    _userProfileEventController.stream.listen(_mapEventToState());
  }

  /*
  Map event to state
   */
  _mapEventToState(){
    _getProfile();
  }

  /*
  Get the profile of the player.
   */
  void _getProfile(){
    Firestore.instance.collection(FirestoreResources.userCollectionName).document(_userId).snapshots().listen((documentSnapshot){
      _profile.add(Player.fromMap(documentSnapshot.data));
    });
  }

  /*
  Dispose all the event and state
   */
  void dispose(){
    _userProfileEventController.close();
    _userProfileStateController.close();
  }


}