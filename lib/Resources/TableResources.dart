import 'package:Surprize/Helper/SQLiteHelper.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:Surprize/Resources/StringResources.dart';


class SQLiteDatabaseResources{

  /// Related to quiz table
  static final String tableQuizFavourite = "favourteQuiz";

  static final String fieldQuizId = "quizId";
  static final String fieldQuizQuestion = "question";
  static final String fieldQuizAnswerOne = "answerOne";
  static final String fieldQuizAnswerTwo = "answerTwo";
  static final String fieldQuizAnswerThree = "answerThree";
  static final String fieldQuizAnswerFour = "answerFour";
  static final String fieldQuizRightAnswer = "rightAnswer";

  static final String fieldQuizLetterId = "quizLetterId";
  static final String fieldQuizLetterSubject = "subject";
  static final String fieldQuizLetterBody = "body";
  static final String fieldQuizLetterURL = "url";
  static final String fieldQuizLetterCreationTime  = "createdTime";

  static final String fieldQuizLetterDisplayId = "id";
  static final String fieldQuizLetterLiked = "isLiked";
  static final String fieldQuizLetterExpanded = "isExpanded";
  static final String fieldQuizLetterBodyReveal= "revealBody";
  static final String fieldQuizLetterUserId = "userId";

  /// Related to user profile

  static String getProfileTable(){
    return SQLiteHelper.createTable("Players") +
        SQLiteHelper.primaryColumn(FirestoreResources.fieldPlayerId) + "," +
        SQLiteHelper.column(FirestoreResources.fieldPlayerAccountVerified) + "," +
        SQLiteHelper.column(FirestoreResources.fieldPlayerAddress) + "," +
        SQLiteHelper.column(FirestoreResources.fieldPlayerCountry) + "," +
        SQLiteHelper.column(FirestoreResources.fieldPlayerDOB) + "," +
        SQLiteHelper.column(FirestoreResources.fieldPlayerEmail) + "," +
        SQLiteHelper.column(FirestoreResources.fieldPlayerGender) + "," +
        SQLiteHelper.column(FirestoreResources.fieldPlayerMembershipDate) + "," +
        SQLiteHelper.column(FirestoreResources.fieldPlayerName) + "," +
        SQLiteHelper.column(FirestoreResources.fieldPlayerPhoneNumber) + "," +
        SQLiteHelper.column(FirestoreResources.fieldPlayerProfileURL) +
     ")";
  }


  /// get quiz table creation string
  static String getFavouriteTable(){
    return SQLiteHelper.createTable(tableQuizFavourite) +
        SQLiteHelper.primaryColumn(fieldQuizLetterDisplayId) + "," +
        SQLiteHelper.column(fieldQuizLetterId) + "," +
        SQLiteHelper.column(fieldQuizLetterUserId) + "," +
        SQLiteHelper.column(fieldQuizLetterSubject) + "," +
        SQLiteHelper.column(fieldQuizLetterBody) + "," +
        SQLiteHelper.column(fieldQuizLetterCreationTime) + "," +
        SQLiteHelper.column(fieldQuizLetterURL) + "," +
        getQuizTable() + "," +
        getQuizLetterPreferenceTable() + ")";
  }



  /// Get quiz letter table creation string
  static String getQuizTable(){
    return SQLiteHelper.column(fieldQuizId) + "," +
        SQLiteHelper.column(fieldQuizQuestion) + "," +
        SQLiteHelper.column(fieldQuizAnswerOne) + "," +
        SQLiteHelper.column(fieldQuizAnswerTwo) + "," +
        SQLiteHelper.column(fieldQuizAnswerThree) + "," +
        SQLiteHelper.column(fieldQuizAnswerFour) + "," +
        SQLiteHelper.column(fieldQuizRightAnswer);
  }


  /// Get quiz letter preference table creation string
  static String getQuizLetterPreferenceTable(){
    return SQLiteHelper.column(fieldQuizLetterLiked) + "," +
        SQLiteHelper.column(fieldQuizLetterExpanded) + "," +
        SQLiteHelper.column(fieldQuizLetterBodyReveal);
  }

  /// Get insert value field
  static String getInsertValueField(int number){
    String text = "VALUES(";
    for(int n = 0; n < number; n++){
      text = text + "?";
      if(n != number - 1)
        text = text + ",";
    }
    text = text + ")";
    return text;
  }

  /// Insert statement for favourite quote
  static final String insertIntoFavQuoteTableStatement =  SQLiteHelper.insertStatement(tableQuizFavourite) +
  SQLiteHelper.insertColumnAppend([
    fieldQuizLetterDisplayId,
    fieldQuizLetterId,
    fieldQuizLetterUserId,
    fieldQuizLetterSubject,
    fieldQuizLetterBody,
    fieldQuizLetterCreationTime,
    fieldQuizLetterURL,
    fieldQuizId,
    fieldQuizQuestion,
    fieldQuizAnswerOne,
    fieldQuizAnswerTwo,
    fieldQuizAnswerThree,
    fieldQuizAnswerFour,
    fieldQuizRightAnswer,
    fieldQuizLetterLiked,
    fieldQuizLetterExpanded,
    fieldQuizLetterBodyReveal
  ]) + ") " + getInsertValueField(17);

/// Insert statement for profile
  static final String insertIntoProfile = SQLiteHelper.insertStatement("Players") + SQLiteHelper.insertColumnAppend([
    FirestoreResources.fieldPlayerId,
    FirestoreResources.fieldPlayerAccountVerified,
    FirestoreResources.fieldPlayerAddress,
    FirestoreResources.fieldPlayerCountry,
    FirestoreResources.fieldPlayerDOB,
    FirestoreResources.fieldPlayerEmail,
    FirestoreResources.fieldPlayerGender,
    FirestoreResources.fieldPlayerMembershipDate,
    FirestoreResources.fieldPlayerName,
    FirestoreResources.fieldPlayerPhoneNumber,
    FirestoreResources.fieldPlayerProfileURL
  ]) + ") " + getInsertValueField(11);

  /// Update player profile statement
    static final String updateIntoProfile = 'UPDATE Players SET ' +
        FirestoreResources.fieldPlayerAccountVerified + ' =? ' + ',' +
        FirestoreResources.fieldPlayerAddress + ' =? ' + ',' +
        FirestoreResources.fieldPlayerCountry + ' =? ' + ',' +
        FirestoreResources.fieldPlayerDOB + ' =? ' + ',' +
        FirestoreResources.fieldPlayerEmail + ' =? ' + ',' +
        FirestoreResources.fieldPlayerGender + ' =? ' + ',' +
        FirestoreResources.fieldPlayerName + ' =? ' + ',' +
        FirestoreResources.fieldPlayerPhoneNumber + ' =? ' + ',' +
        FirestoreResources.fieldPlayerProfileURL + ' =? ' +
        'WHERE ' +
        FirestoreResources.fieldPlayerId + ' =?';


}