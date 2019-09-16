import 'package:Surprize/Helper/SQLiteHelper.dart';


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

  static final String fieldQuizLetterLiked = "isLiked";
  static final String fieldQuizLetterExpanded = "isExpanded";
  static final String fieldQuizLetterBodyReveal= "revealBody";
  static final String fieldQuizLetterUserId = "userId";



  /// get quiz table creation string
  static String getFavouriteTable(){
    return SQLiteHelper.createTable(tableQuizFavourite) +
        SQLiteHelper.primaryColumn(fieldQuizLetterId) + "," +
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

  static final String insertIntoFavQuoteTableStatement =  SQLiteHelper.insertStatement(tableQuizFavourite) +
  SQLiteHelper.insertColumnAppend([
    SQLiteDatabaseResources.fieldQuizLetterId,
    SQLiteDatabaseResources.fieldQuizLetterUserId,
    SQLiteDatabaseResources.fieldQuizLetterSubject,
    SQLiteDatabaseResources.fieldQuizLetterBody,
    SQLiteDatabaseResources.fieldQuizLetterCreationTime,
    SQLiteDatabaseResources.fieldQuizLetterURL,
    SQLiteDatabaseResources.fieldQuizId,
    SQLiteDatabaseResources.fieldQuizQuestion,
    SQLiteDatabaseResources.fieldQuizAnswerOne,
    SQLiteDatabaseResources.fieldQuizAnswerTwo,
    SQLiteDatabaseResources.fieldQuizAnswerThree,
    SQLiteDatabaseResources.fieldQuizAnswerFour,
    SQLiteDatabaseResources.fieldQuizRightAnswer,
    SQLiteDatabaseResources.fieldQuizLetterLiked,
    SQLiteDatabaseResources.fieldQuizLetterExpanded,
    SQLiteDatabaseResources.fieldQuizLetterBodyReveal
  ]) + ") " + getInsertValueField(16);

}