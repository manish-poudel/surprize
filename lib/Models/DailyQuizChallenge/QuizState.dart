import 'package:surprize/Helper/AppHelper.dart';
import 'package:surprize/Models/DailyQuizChallenge/CurrentQuizState.dart';
import 'package:surprize/Resources/FirestoreResources.dart';

class QuizState{
  DateTime _quizStartTime;
  CurrentQuizState _currentQuizState;
  String _currentQuizId;

  QuizState(this._currentQuizState, this._currentQuizId, this._quizStartTime);

  DateTime get quizStartTime => _quizStartTime;
  CurrentQuizState get quizState => _currentQuizState;
  String get currentQuizId => _currentQuizId;


  QuizState.fromMap(Map<dynamic, dynamic> map){
    _currentQuizState = _convertStringToEnum(map[FirestoreResources.fieldQuizState]);
    _currentQuizId = map[FirestoreResources.fieldCurrentQuizId];
    _quizStartTime = AppHelper.convertToDateTime(map[FirestoreResources.fieldQuizStartTime]);
  }

  /// Convert enum to string
  CurrentQuizState _convertStringToEnum(String currentQuizState){
    switch(currentQuizState){
      case "QUIZ_IS_OFF":
        return CurrentQuizState.QUIZ_IS_OFF;
      case "QUIZ_IS_ON_AND_QUESTION_IS_NOT_BEING_DISPLAYED":
        return CurrentQuizState.QUIZ_IS_ON_AND_QUESTION_IS_NOT_BEING_DISPLAYED;
      case "QUIZ_IS_ON_AND_QUESTION_IS_BEING_DISPLAYED":
        return CurrentQuizState.QUIZ_IS_ON_AND_QUESTION_IS_BEING_DISPLAYED;
      default:
        return CurrentQuizState.UNKNOWN;
    }
  }

}