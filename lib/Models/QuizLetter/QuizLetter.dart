import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Models/DailyQuizChallenge/DailyQuizChallengeQnA.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

class QuizLetter{
  String quizLettersId;
  String quizLettersSubject;
  String quizLettersBody;
  String quizLettersUrl;
  DateTime addedDate;
  DailyQuizChallengeQnA dailyQuizChallengeQnA;

  QuizLetter(this.quizLettersId, this.quizLettersSubject, this.quizLettersBody, this.quizLettersUrl, this.dailyQuizChallengeQnA);

  QuizLetter.fromMap(Map<String, dynamic> map){
    quizLettersId = map[FirestoreResources.fieldQuizLetterId];
    quizLettersSubject = map[FirestoreResources.fieldQuizLetterSubject];
    quizLettersBody = map[FirestoreResources.fieldQuizLetterBody];
    quizLettersUrl = map[FirestoreResources.fieldQuizLetterImage];
    addedDate = AppHelper.convertToDateTime(map[FirestoreResources.fieldQuizLetterAddedDate]);
    dailyQuizChallengeQnA = DailyQuizChallengeQnA.fromMap(Map<String, dynamic>.from(map[FirestoreResources.fieldQuizLetterQuiz]));
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map[FirestoreResources.fieldQuizLetterAddedDate] = addedDate;
    map[FirestoreResources.fieldQuizLetterId] = quizLettersId;
    map[FirestoreResources.fieldQuizLetterSubject] = quizLettersSubject;
    map[FirestoreResources.fieldQuizLetterBody] = quizLettersBody;
    map[FirestoreResources.fieldQuizLetterImage] = quizLettersUrl;
    map[FirestoreResources.fieldQuizLetterQuiz] = dailyQuizChallengeQnA.toMap();

    return map;
  }
}