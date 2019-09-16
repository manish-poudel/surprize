import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:Surprize/Resources/TableResources.dart';

class DailyQuizChallengeQnA {

  String _quizId;
  String _question;
  List<String> _answer;
  int _rightAnswer;

  DailyQuizChallengeQnA(this._quizId, this._question, this._answer, this._rightAnswer);

  String get question => _question;
  String get id => _quizId;
  List<String> get answers => _answer;
  int get rightAnswer => _rightAnswer;


  DailyQuizChallengeQnA.fromMap(Map<String, dynamic> map){
    _quizId = map[FirestoreResources.fieldQuizId];
    _question = map[FirestoreResources.fieldQuizQuestion];
    _answer = map[FirestoreResources.fieldQuizAnswers].cast<String>();
    _rightAnswer = map[FirestoreResources.fieldQuizCorrectAnswer];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[FirestoreResources.fieldQuizId] = _quizId;
    map[FirestoreResources.fieldQuizQuestion] = _question;
    map[FirestoreResources.fieldQuizAnswers] = answers;
    map[FirestoreResources.fieldQuizCorrectAnswer] = _rightAnswer;
    return map;
  }

  DailyQuizChallengeQnA.fromSQLiteMap(Map<String, dynamic> map){
    _quizId = map[SQLiteDatabaseResources.fieldQuizId];
    _question = map[SQLiteDatabaseResources.fieldQuizQuestion];
    _answer = [map[SQLiteDatabaseResources.fieldQuizAnswerOne],
      map[SQLiteDatabaseResources.fieldQuizAnswerTwo],
      map[SQLiteDatabaseResources.fieldQuizAnswerThree],
      map[SQLiteDatabaseResources.fieldQuizAnswerOne]];
    _rightAnswer = int.parse(map[SQLiteDatabaseResources.fieldQuizRightAnswer]);
  }
}