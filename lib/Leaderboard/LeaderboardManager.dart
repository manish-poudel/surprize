import 'dart:async';

import 'package:Surprize/Models/DailyQuizChallenge/enums/PlayState.dart';
import 'package:Surprize/Models/DailyQuizChallenge/QuizPlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Surprize/Firestore/FirestoreOperations.dart';
import 'package:Surprize/Leaderboard/ScoreSystem.dart';
import 'package:Surprize/Models/Leaderboard.dart';
import 'package:Surprize/Models/Player.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

/// Singleton leaderboard manager class for handling all operation related to leaderboard

class LeaderboardManager{

  String _userId;
  int _totalScore;
  int _totalRightAnswer;

  bool _isDailyQuizWinner;


  /// Save score after game play
  void saveScoreAfterGamePlay(int totalRightAnswer,int scoreFromQuizPlay, String playedQuizId, String playedQuizName, Function allTimeScoredSaved, Function weeklyScoredSaved, Function dailyQuizWinnerSaved){

    this._totalRightAnswer = totalRightAnswer;
    FirebaseAuth.instance.currentUser().then((firebaseUser){
      _userId = firebaseUser.uid;
      _totalScore = scoreFromQuizPlay + ScoreSystem.getScoreFromGamePlay();

      saveForAllTimeScore(_userId,_totalScore, (value){
        allTimeScoredSaved(value);
      });

      saveForWeeklyScore(_userId, _totalScore,(value){
        weeklyScoredSaved(value);
      });

      _saveForDailyQuizWinner(scoreFromQuizPlay ,playedQuizId, playedQuizName, (value){
        dailyQuizWinnerSaved(value);
      });
    });
  }


  /// Save score for all time
  void saveForAllTimeScore(String id, int score, Function allTimeScoreSaved){
   _saveToFirestore(id, score, FirestoreResources.leaderboardAllTime, (value){
     allTimeScoreSaved(value);
   });
  }

  /// Save score for weekly
  void saveForWeeklyScore(String id, int score, Function weeklyScoredSaved){
    _saveToFirestore(id, score, FirestoreResources.leaderboardWeekly, (value){
      weeklyScoredSaved(value);
    });
  }

  /// Save for daily quiz winner
  void _saveForDailyQuizWinner(int scoreFromQuiz, String playedQuizId, String quizName, Function dailyQuizWinnerSaved){

    print("About to save user in leaderboard daily");
    _isDailyQuizWinner = (scoreFromQuiz == ScoreSystem.getFullSoreFromQuizPlay());

    QuizPlay quizPlay;
    quizPlay = _isDailyQuizWinner?QuizPlay(PlayState.WON, DateTime.now(),playedQuizId,quizName, _totalScore,_totalRightAnswer):QuizPlay(PlayState.LOST,DateTime.now(), playedQuizId, quizName, _totalScore,_totalRightAnswer);
    DocumentReference leaderboardDocRef = FirestoreOperations().getNestedCollectionReference(FirestoreResources.leaderboardCollection,
        FirestoreResources.leaderboardSubCollection, FirestoreResources.leaderboardDaily).document(_userId);
    leaderboardDocRef.setData(quizPlay.toMap()).then((value){
      dailyQuizWinnerSaved(value);
    }).catchError((error){
      print("THE ERROR WHILE SAVING DAILY WINNER" + error.toString());
    });
  }


  /// Save score to the database
  void _saveToFirestore(String id, int totalScore, String leaderboardType, Function scoredSaved){
      DocumentReference leaderboardDocRef =   FirestoreOperations().getNestedCollectionReference(FirestoreResources.leaderboardCollection,
        FirestoreResources.leaderboardSubCollection, leaderboardType).document(id);

      /// For saving score weekly and all time basis
      if(leaderboardType == FirestoreResources.leaderboardAllTime || leaderboardType == FirestoreResources.leaderboardWeekly){
        _saveScore(totalScore, leaderboardDocRef, (value){
          scoredSaved(value);
        });
      }
  }

  /// Save score to the firestore
  void _saveScore(int totalScore, DocumentReference documentReference, Function scoreSaved){
    int oldScore;
    documentReference.get().then((documentSnapshot){
      (!documentSnapshot.exists) ? oldScore = 0: oldScore =  documentSnapshot.data[FirestoreResources.fieldLeaderBoardScore];
      documentReference.setData({
        FirestoreResources.fieldLeaderBoardScore: (oldScore + totalScore)
      }).catchError((error){
        scoreSaved(false);
      }).then((value){
        scoreSaved(true);
      });
    });
  }


/// Get all time score
  getScorer(String leaderboardType, String fieldValue, Function getScorer) async {
  /// Get all the score data
   QuerySnapshot querySnapshot = await FirestoreOperations().getNestedCollectionReference(FirestoreResources.leaderboardCollection,
        FirestoreResources.leaderboardSubCollection, leaderboardType).orderBy(fieldValue, descending: true).getDocuments();

   List<DocumentSnapshot> docSnapshot = querySnapshot.documents.toList();
   if(docSnapshot.length == 0){
     getScorer(null);
     return;
   }
   /// Add to leaderboard list
    docSnapshot.forEach((documentSnapshot)  async {
      Player player = await getProfileData(documentSnapshot.documentID);
      if(player == null)
        return;
      getScorer(Leaderboard(docSnapshot.indexOf(documentSnapshot) + 1,player, documentSnapshot.data[fieldValue], player.accountVerified));
     });
  }

/// Get daily Score winner
  Future<Stream<DocumentSnapshot>> getDailyScoreWinner(String uid) async {
    return  FirestoreOperations().getNestedCollectionReference(
        FirestoreResources.leaderboardCollection,
        FirestoreResources.leaderboardSubCollection,
        FirestoreResources.leaderboardDaily).document(uid).snapshots();
  }


/// Get player data
  Future<Player> getProfileData(String id) async {
    DocumentSnapshot documentSnapshot = await FirestoreOperations().getDocumentSnapshot(FirestoreResources.userCollectionName
        ,id).get();
    Player player;
    try {
      player = Player.fromMap(documentSnapshot.data);
    }
    catch(error){

    }
    return player;
  }


}