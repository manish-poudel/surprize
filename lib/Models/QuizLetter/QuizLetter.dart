import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Models/DailyQuizChallenge/DailyQuizChallengeQnA.dart';
import 'package:Surprize/Models/QuizDataState.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:Surprize/Resources/TableResources.dart';

class QuizLetter{
  String quizLettersId;
  String quizLettersSubject;
  String quizLettersBody;
  String quizLettersUrl;
  DateTime addedDate;
  QuizDataState quizDataState;
  DailyQuizChallengeQnA dailyQuizChallengeQnA;

  QuizLetter(this.quizLettersId, this.quizLettersSubject, this.quizLettersBody, this.quizLettersUrl, this.dailyQuizChallengeQnA,this.quizDataState);

  QuizLetter.fromMap(Map<String, dynamic> map){
    quizLettersId = map[FirestoreResources.fieldQuizLetterId];
    quizLettersSubject = map[FirestoreResources.fieldQuizLetterSubject];
    quizLettersBody = map[FirestoreResources.fieldQuizLetterBody];
    quizLettersUrl = map[FirestoreResources.fieldQuizLetterImage];
    addedDate = AppHelper.convertToDateTime(map[FirestoreResources.fieldQuizLetterAddedDate]);
    quizDataState = convertStringToEnum(map[FirestoreResources.fieldQuizLetterState]);
    dailyQuizChallengeQnA = DailyQuizChallengeQnA.fromMap(Map<String, dynamic>.from(map[FirestoreResources.fieldQuizLetterQuiz]));
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map[FirestoreResources.fieldQuizLetterAddedDate] = addedDate;
    map[FirestoreResources.fieldQuizLetterId] = quizLettersId;
    map[FirestoreResources.fieldQuizLetterSubject] = quizLettersSubject;
    map[FirestoreResources.fieldQuizLetterBody] = quizLettersBody;
    map[FirestoreResources.fieldQuizLetterImage] = quizLettersUrl;
    map[FirestoreResources.fieldQuizLetterState] = convertEnumToString(quizDataState);
    map[FirestoreResources.fieldQuizLetterQuiz] = dailyQuizChallengeQnA.toMap();

    return map;
  }


  QuizLetter.fromSQLiteMap(Map<String, dynamic> map, DailyQuizChallengeQnA dailyQuizChallenge){
    quizLettersId = map[SQLiteDatabaseResources.fieldQuizLetterId];
    quizLettersSubject = map[SQLiteDatabaseResources.fieldQuizLetterSubject];
    quizLettersBody = map[SQLiteDatabaseResources.fieldQuizLetterBody];
    quizLettersUrl = map[SQLiteDatabaseResources.fieldQuizLetterURL];
    addedDate = DateTime.now();
    dailyQuizChallengeQnA = dailyQuizChallenge;
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