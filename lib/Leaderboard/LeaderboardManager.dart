import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Surprize/Firestore/FirestoreOperations.dart';
import 'package:Surprize/Leaderboard/ScoreSystem.dart';
import 'package:Surprize/Models/Leaderboard.dart';
import 'package:Surprize/Models/Player.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

/// Singleton leaderboard manager class for handling all operation related to leaderboard

class LeaderboardManager{
  static final LeaderboardManager _leaderboardManager = new LeaderboardManager._internal();
  String _userId;
  int _totalScore;

  bool _isDailyQuizWinner;

  factory LeaderboardManager(){
    return  _leaderboardManager;
  }

  LeaderboardManager._internal();

  /// Save score after game play
  void saveScoreAfterGamePlay(int scoreFromQuizPlay, Function allTimeScoredSaved, Function weeklyScoredSaved, Function dailyQuizWinnerSaved){

    FirebaseAuth.instance.currentUser().then((firebaseUser){
      _userId = firebaseUser.uid;
      _totalScore = scoreFromQuizPlay + ScoreSystem.getScoreFromGamePlay();

      saveForAllTimeScore((value){
        allTimeScoredSaved(value);
      });
      saveForWeeklyScore((value){
        weeklyScoredSaved(value);
      });
      _saveForDailyQuizWinner(scoreFromQuizPlay , (value){
        dailyQuizWinnerSaved(value);
      });
    });
  }


  ///Save score after sharing
  saveScoreAfterSharing(Function allTimeScoredSaved, Function weeklyScoredSaved){
    _totalScore = ScoreSystem.getSoreFromSharingApp("Facebook");
    saveForAllTimeScore((value){
      allTimeScoredSaved(value);
    });
    saveForWeeklyScore((value){
      weeklyScoredSaved(value);
    });
  }

  /// Save score for all time
  void saveForAllTimeScore(Function allTimeScoreSaved){
   _saveToFirestore(FirestoreResources.leaderboardAllTime, (value){
     allTimeScoreSaved(value);
   });
  }

  /// Save score for weekly
  void saveForWeeklyScore(Function weeklyScoredSaved){
    _saveToFirestore(FirestoreResources.leaderboardWeekly, (value){
      weeklyScoredSaved(value);
    });
  }

  /// Save for daily quiz winner
  void _saveForDailyQuizWinner(int scoreFromQuiz, Function dailyQuizWinnerSaved){

    _isDailyQuizWinner = false;
    /// if user has received full score
    if(scoreFromQuiz == ScoreSystem.getFullSoreFromQuizPlay()){
      _isDailyQuizWinner = true;
    }
    _saveToFirestore(FirestoreResources.leaderboardDaily ,(value){
      dailyQuizWinnerSaved(value);
    });
  }

  /// Save score to the database
  void _saveToFirestore(String leaderboardType, Function scoredSaved){
      DocumentReference leaderboardDocRef =   FirestoreOperations().getNestedCollectionReference(FirestoreResources.leaderboardCollection,
        FirestoreResources.leaderboardSubCollection, leaderboardType).document(_userId);

      /// For saving score weekly and all time basis
      if(leaderboardType == FirestoreResources.leaderboardAllTime || leaderboardType == FirestoreResources.leaderboardWeekly){
        _saveScore(leaderboardDocRef, (value){
          scoredSaved(value);
        });
      }

      else if(leaderboardType == FirestoreResources.leaderboardDaily){
        _saveDailyQuizWinner(leaderboardDocRef,(value){
          scoredSaved(value);
        });
      }
  }

  /// Save score to the firestore
  void _saveScore(DocumentReference documentReference, Function scoreSaved){
    int oldScore;
    documentReference.get().then((documentSnapshot){
      (!documentSnapshot.exists) ? oldScore = 0: oldScore =  documentSnapshot.data[FirestoreResources.fieldLeaderBoardScore];

      documentReference.setData({
        FirestoreResources.fieldLeaderBoardScore: (oldScore + _totalScore)
      }).catchError((error){
        scoreSaved(false);
      }).then((value){
        scoreSaved(true);
      });
    });
  }

  /// Save daily quiz winner
  void _saveDailyQuizWinner(DocumentReference documentReference, Function scoreSaved){
   documentReference.setData({
     FirestoreResources.fieldDailyQuizWinner: _isDailyQuizWinner
   }).then((value){
     scoreSaved(true);
   }).catchError((error){
     scoreSaved(false);
   });
  }

/// Get all time score
  getScorer(String leaderboardType, String fieldValue, Function getScorer) async {
  /// Get all the score data
   QuerySnapshot querySnapshot = await FirestoreOperations().getNestedCollectionReference(FirestoreResources.leaderboardCollection,
        FirestoreResources.leaderboardSubCollection, leaderboardType).orderBy(fieldValue, descending: true).limit(10).getDocuments();

   List<DocumentSnapshot> docSnapshot = querySnapshot.documents.toList();
   /// Add to leaderboard list
    docSnapshot.forEach((documentSnapshot)  async {
      Player player = await getProfileData(documentSnapshot.documentID);
      getScorer(Leaderboard(docSnapshot.indexOf(documentSnapshot) + 1,player, documentSnapshot.data[fieldValue]));
     });
  }

/// Get daily Score winner
  Future<bool> getDailyScoreWinner(String uid) async {
    DocumentSnapshot documentSnapshot = await FirestoreOperations().getNestedCollectionReference(FirestoreResources.leaderboardCollection,
        FirestoreResources.leaderboardSubCollection, FirestoreResources.leaderboardDaily).document(uid).get();
    return documentSnapshot.data[FirestoreResources.fieldDailyQuizWinner];
  }

/// Get player data
  Future<Player> getProfileData(String id) async {
    DocumentSnapshot documentSnapshot = await FirestoreOperations().getDocumentSnapshot(FirestoreResources.userCollectionName
        , id).get();
    Player player = Player.fromMap(documentSnapshot.data);
    return player;
  }


}