import 'package:surprize/Resources/FirestoreResources.dart';

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

}