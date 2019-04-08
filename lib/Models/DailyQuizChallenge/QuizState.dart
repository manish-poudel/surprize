import 'package:surprize/Resources/FirestoreResources.dart';

class QuizState{
  bool _isQuizGameAvailable;
  bool _startQuiz;
  String _currentQuizId;

  QuizState(this._isQuizGameAvailable, this._startQuiz, this._currentQuizId);


  bool get isDailyQuizChallengeOn => _isQuizGameAvailable;
  bool get isSwitchOn => _startQuiz;
  String get currentQuizId => _currentQuizId;

  /*
  Convert from map to object
   */
  QuizState.fromMap(Map<dynamic, dynamic> map){
    _isQuizGameAvailable = map[FirestoreResources.fieldQuizGameAvailable];
    _startQuiz = map[FirestoreResources.fieldQuizPlay];
    _currentQuizId = map[FirestoreResources.fieldCurrentQuizId];
  }
}