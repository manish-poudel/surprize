import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Models/DailyQuizChallenge/enums/CurrentQuizState.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

class QuizState{

  String quizId;
  String quizName;
  DateTime _quizStartTime;
  CurrentQuizState _currentQuizState;

  QuizState(this.quizId, this.quizName, this._currentQuizState, this._quizStartTime);

  DateTime get quizStartTime => _quizStartTime;
  CurrentQuizState get quizState => _currentQuizState;

  QuizState.fromMap(Map<dynamic, dynamic> map){
    _currentQuizState = _convertStringToEnum(map[FirestoreResources.fieldQuizState]);
    _quizStartTime = AppHelper.convertToDateTime(map[FirestoreResources.fieldQuizStartTime]);
    quizId = map[FirestoreResources.fieldQuizStateId];
    quizName = map[FirestoreResources.fieldQuizName];
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

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[FirestoreResources.fieldQuizState] =
        convertEnumToString(_currentQuizState);
    map[FirestoreResources.fieldQuizStartTime] = _quizStartTime;
    map[FirestoreResources.fieldQuizStateId] = quizId;
    map[FirestoreResources.fieldQuizName] = quizName;
    return map;
  }


  /// Convert enum to string
  static CurrentQuizState convertStringToEnum(String currentQuizState) {
    switch (currentQuizState) {
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

  /// Convert enum to string
  static String convertEnumToString(CurrentQuizState currentQuizState) {
    switch (currentQuizState) {
      case CurrentQuizState.QUIZ_IS_OFF:
        return "QUIZ_IS_OFF";
      case CurrentQuizState.QUIZ_IS_ON_AND_QUESTION_IS_NOT_BEING_DISPLAYED:
        return "QUIZ_IS_ON_AND_QUESTION_IS_NOT_BEING_DISPLAYED";
      case CurrentQuizState.QUIZ_IS_ON_AND_QUESTION_IS_BEING_DISPLAYED:
        return "QUIZ_IS_ON_AND_QUESTION_IS_BEING_DISPLAYED";
      default:
        return "UNKNOWN";
    }
  }
}