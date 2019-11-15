import 'package:Surprize/Helper/AppHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/Models/DailyQuizChallenge/enums/CurrentQuizState.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

import 'SurprizeGamePlayPage.dart';
import 'DailyQuizChallengeNotAvailablePage.dart';
import 'package:Surprize/Models/DailyQuizChallenge/enums/QuizState.dart';

class SurprizeChallengePage {

  BuildContext  _context;
  SurprizeChallengePage(this._context);

  /// Open page
  openPage() async {
    QuizState quizState = await dailyQuizState();
    goToPage(quizState.quizState != CurrentQuizState.QUIZ_IS_OFF?SurprizeGamePlayPage():
        DailyQuizChallengeNotAvailablePage(quizState.quizStartTime)
        , _context);
  }

  /// Check if quiz is on
  Future<QuizState> dailyQuizState() async {
    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(
        FirestoreResources.collectionQuizName).document(FirestoreResources.fieldQuizDocumentName).get();
    return QuizState.fromMap(documentSnapshot.data);
  }

  /// Listen for daily quiz game on
   listenForDailyQuizGameOn(Function value){
    Firestore.instance.collection(
        FirestoreResources.collectionQuizName).document(FirestoreResources.fieldQuizDocumentName).snapshots().listen((snapshot){
       value(QuizState.fromMap(snapshot.data));
    });
  }

  /// Go to page
  goToPage(var page, context) {
    AppHelper.cupertinoRoute(context, page);
  }
}


