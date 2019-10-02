import 'package:Surprize/Models/QuizDataState.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:Surprize/Resources/TableResources.dart';

class DailyQuizChallengeQnA {

  String _quizId;
  String _question;
  List<String> _answer;
  int _rightAnswer;
  QuizDataState _state;

  DailyQuizChallengeQnA(this._quizId, this._question, this._answer, this._rightAnswer, this._state);

  String get question => _question;
  String get id => _quizId;
  List<String> get answers => _answer;
  int get rightAnswer => _rightAnswer;
  QuizDataState get state => _state;


  DailyQuizChallengeQnA.fromMap(Map<String, dynamic> map){
    _quizId = map[FirestoreResources.fieldQuizId];
    _question = map[FirestoreResources.fieldQuizQuestion];
    _answer = map[FirestoreResources.fieldQuizAnswers].cast<String>();
    _rightAnswer = map[FirestoreResources.fieldQuizCorrectAnswer];
    _state = convertStringToEnum(map[FirestoreResources.fieldDailyQuizState]);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[FirestoreResources.fieldQuizId] = _quizId;
    map[FirestoreResources.fieldQuizQuestion] = _question;
    map[FirestoreResources.fieldQuizAnswers] = answers;
    map[FirestoreResources.fieldQuizCorrectAnswer] = _rightAnswer;
    map[FirestoreResources.fieldDailyQuizState] = convertEnumToString(_state);
    return map;
  }

  DailyQuizChallengeQnA.fromSQLiteMap(Map<String, dynamic> map){
    _quizId = map[SQLiteDatabaseResources.fieldQuizId];
    _question = map[SQLiteDatabaseResources.fieldQuizQuestion];
    _answer = [map[SQLiteDatabaseResources.fieldQuizAnswerOne],
      map[SQLiteDatabaseResources.fieldQuizAnswerTwo],
      map[SQLiteDatabaseResources.fieldQuizAnswerThree],
      map[SQLiteDatabaseResources.fieldQuizAnswerFour]];
    _rightAnswer = int.parse(map[SQLiteDatabaseResources.fieldQuizRightAnswer]);
  }

  /// Convert enum to string
  QuizDataState convertStringToEnum(String quizDataState){
    switch(quizDataState){
      case "ACTIVE":
        return QuizDataState.ACTIVE;
      case "DELETED":
        return QuizDataState.DELETED;
      default:
        return QuizDataState.UNKNOWN;
    }
  }

  /// Convert enum to string
  static String convertEnumToString(QuizDataState quizDataState) {
    switch (quizDataState) {
      case QuizDataState.ACTIVE:
        return "ACTIVE";
      case QuizDataState.DELETED:
        return "DELETED";
      default:
        return "UNKNOWN";
    }
  }
}