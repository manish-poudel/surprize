import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/Models/DailyQuizChallenge/CurrentQuizState.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

import 'DailyQuizChallengeGamePlayPage.dart';
import 'DailyQuizChallengeNotAvailablePage.dart';
import 'Models/DailyQuizChallenge/QuizState.dart';

class DailyQuizChallengePage {

  BuildContext  _context;
  DailyQuizChallengePage(this._context);

  /// Open page
  openPage() async {
    QuizState quizState = await dailyQuizState();
    goToPage(quizState.quizState != CurrentQuizState.QUIZ_IS_OFF?DailyQuizChallengeGamePlayPage():
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
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => page));
  }
}


