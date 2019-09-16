import 'dart:async';

import 'package:Surprize/Models/DailyQuizChallenge/DailyQuizChallengeQnA.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetter.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetterDisplay.dart';
import 'package:Surprize/Resources/TableResources.dart';
import 'package:Surprize/SqliteDb/SQLiteManager.dart';

/// Quiz letter bloc class to get all the profile.
class QuizLetterBLOC {

  Map<String, QuizLetterDisplay> _quizLettersMap;

  final _quizLetterController = StreamController<Map<String, QuizLetterDisplay>>.broadcast();
  StreamSink<Map<String,QuizLetterDisplay>> get _quizLetters  => _quizLetterController.sink;
  Stream<Map<String, QuizLetterDisplay>> get quizLetters => _quizLetterController.stream;


  QuizLetterBLOC() {
    getQuizLetters();
  }

  // Get all quiz letters
  getQuizLetters() async {
    _quizLettersMap = new Map();
    List list = await SQLiteManager().getAllQuotes();
    if(list == null)
      return;
    if (list.length == 0) {
      _quizLetters.add(_quizLettersMap);
    } else {
      list.forEach((quizLettersMap) {
        QuizLetterDisplay quizLetterDisplay = createQuizLetter(quizLettersMap);
        _quizLettersMap.putIfAbsent(quizLetterDisplay.quizLetter.quizLettersId, () => quizLetterDisplay);
        _quizLetters.add(_quizLettersMap);
      });
    }
  }

  // Insert quiz letter
  insertQuizLetter(QuizLetterDisplay quizLetterDisplay) async {
    print("Inserting");
    await SQLiteManager().insertFavouriteQuote(quizLetterDisplay);
    getQuizLetters();
  }

  /// Delete quiz letters
  Future<int> deleteQuizLetter(String uid) async {
    int result = await SQLiteManager().deleteFavouriteQuote(uid);
    _quizLettersMap.remove(uid);
    _quizLetters.add(_quizLettersMap);
    return result;
  }

  /// Close all the controller
  dispose() {
    _quizLetterController.close();
  }

  /// Create quiz letter from map
  QuizLetterDisplay createQuizLetter(Map map) {
    DailyQuizChallengeQnA dailyQuizChallengeQnA = DailyQuizChallengeQnA.fromSQLiteMap(map);
    QuizLetter quizLetter = QuizLetter.fromSQLiteMap(map, dailyQuizChallengeQnA);;
    return QuizLetterDisplay(
        map[SQLiteDatabaseResources.fieldQuizLetterDisplayId],
        map[SQLiteDatabaseResources.fieldQuizLetterLiked] == "true",
        quizLetter,
        map[SQLiteDatabaseResources.fieldQuizLetterExpanded] == "true",
        map[SQLiteDatabaseResources.fieldQuizLetterBodyReveal] == "true");
  }
}
