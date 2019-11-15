import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/Player.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetterDisplay.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:Surprize/Resources/TableResources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';

import 'SQLiteDb.dart';

class SQLiteManager {
  SQLiteDb _sqLiteDatabase;

  String _databaseName = "surprize.db";
  int databaseVersion = 2;

  static final SQLiteManager _sqLiteManager =
  new SQLiteManager._internal();


  factory SQLiteManager() {
    return _sqLiteManager;
  }

  SQLiteManager._internal();

  /// Method for creating database for the first time
  _onCreateDatabase(Database database, int version) async {
    _createTable(database);
  }

  /// Method for Creating table for database v.1
  _createTable(database) async {

    /// Create table for quiz conversation
    await database.execute(SQLiteDatabaseResources.getFavouriteTable()).then((value) {
      print("CREATED TABLE" + value.toString());
    })
        .catchError((error) {
          print("Error occoured on creating table" + error.toString());
    });

    await database.execute(SQLiteDatabaseResources.getProfileTable()).then((_) {
      print("Created table for profile");
    });

  }


  /// Method for upgrading database
  _onUpgradeDatabase(Database database, int oldVersion, int newVersion) async {
    if (oldVersion == 1 && newVersion == 2) {
      /// Create table for quiz conversation
      await database.execute(SQLiteDatabaseResources.getProfileTable()).then((_) {
        print("Created table for profile");
      })
          .catchError((error) {
        print("Error occoured on creating table" + error.toString());
      });
    }
  }

  ///Responsible for creating chat table and initializing database
  initAppDatabase() async {
    if (_sqLiteDatabase == null) {
      _sqLiteDatabase = new SQLiteDb(

        /// Database name
          _databaseName,

          /// On create database
              (database, version) => _onCreateDatabase(database, version),

          /// On Upgrade database
              (database, oldVersion, newVersion) => _onUpgradeDatabase(database, oldVersion, newVersion),

          /// Database current  version
          databaseVersion);
      await _sqLiteDatabase.initDB();
    }
  }

  /// Get sqlite database instance
  Future<SQLiteDb> getSQLiteDatabaseInstance() async {

    if(_sqLiteDatabase != null)
      return _sqLiteDatabase;
    await initAppDatabase();
    return _sqLiteDatabase;
  }


  /// Insert favourite quote
  insertFavouriteQuote(QuizLetterDisplay quizLetterDisplay) async {
    SQLiteDb db = await getSQLiteDatabaseInstance();
    int id = await db.createDataRaw(SQLiteDatabaseResources.insertIntoFavQuoteTableStatement, [
      quizLetterDisplay.quizLetter.quizLettersId + UserMemory().getPlayer().membershipId,
      quizLetterDisplay.quizLetter.quizLettersId,
      UserMemory().getPlayer().membershipId,
      quizLetterDisplay.quizLetter.quizLettersSubject,
      quizLetterDisplay.quizLetter.quizLettersBody,
      quizLetterDisplay.quizLetter.addedDate.toIso8601String(),
      quizLetterDisplay.quizLetter.quizLettersUrl,
      quizLetterDisplay.quizLetter.dailyQuizChallengeQnA.id,
      quizLetterDisplay.quizLetter.dailyQuizChallengeQnA.question,
      quizLetterDisplay.quizLetter.dailyQuizChallengeQnA.answers[0],
      quizLetterDisplay.quizLetter.dailyQuizChallengeQnA.answers[1],
      quizLetterDisplay.quizLetter.dailyQuizChallengeQnA.answers[2],
      quizLetterDisplay.quizLetter.dailyQuizChallengeQnA.answers[3],
      quizLetterDisplay.quizLetter.dailyQuizChallengeQnA.rightAnswer.toString(),
      quizLetterDisplay.quizLetterLiked.toString(),
      quizLetterDisplay.initiallyExpanded.toString(),
      quizLetterDisplay.revealBody.toString()
    ]);
  }

  /// Insert profile
  Future<int> insertProfile(FirebaseUser firebaseUser, Player player) async {
    SQLiteDb db = await getSQLiteDatabaseInstance();
    int id = await db.createDataRaw(SQLiteDatabaseResources.insertIntoProfile, [
      player.membershipId,
      firebaseUser.isEmailVerified.toString(),
      player.address,
      player.country,
      player.dob,
      player.email,
      player.gender,
      player.membershipDate.toIso8601String() + "&&&" + player.membershipDate.millisecondsSinceEpoch.toString(),
      player.name,
      player.phoneNumber,
      player.profileImageURL
    ]);
    print("player inserted: " + id.toString());
    return id;
  }

  /// Update into profile
  updateProfile(Player player) async {
    SQLiteDb db = await getSQLiteDatabaseInstance();
    int id;
    try {
       id = await db.updateDataRaw(
          SQLiteDatabaseResources.updateIntoProfile, [
        player.accountVerified,
        player.address,
        player.country,
        player.dob,
        player.email,
        player.gender,
        player.name,
        player.phoneNumber,
        player.profileImageURL,
        player.membershipId
      ]);
    }
    catch(error){
      print("Error in upadating profile : " + error.toString());
    }
    print("player updated: " + id.toString());
  }

  /// User profile by id
  getUserProfileById(String id) async {
    var res;
    try {
      SQLiteDb sqLiteDatabase = await getSQLiteDatabaseInstance();
      res = await sqLiteDatabase.getDataByCondition(
          "Players", FirestoreResources.fieldPlayerId + " =?",
          [id]);
    }
    catch(error){
      print(error.toString());
    }
    return res;
  }


  /// Delete favourite quote
  deleteFavouriteQuote(String delId) async {
    SQLiteDb db = await getSQLiteDatabaseInstance();
    int id = await db.deleteData(SQLiteDatabaseResources.tableQuizFavourite,
        SQLiteDatabaseResources.fieldQuizLetterDisplayId + " =? "
            , [delId]);
    print(id.toString() +  "Deleted");
  }

  /// Get all quotes
  getAllQuotes() async {
    SQLiteDb sqLiteDatabase = await getSQLiteDatabaseInstance();
    List<Map> list = await sqLiteDatabase
        .getDataByCondition(SQLiteDatabaseResources.tableQuizFavourite, SQLiteDatabaseResources.fieldQuizLetterUserId + " =?", [UserMemory().firebaseUser.uid]);
    print(list.toString());
    return list;
  }

  /// Get all quotes
  getQuotes(String id) async {
    SQLiteDb sqLiteDatabase = await getSQLiteDatabaseInstance();
    List<Map> list = await sqLiteDatabase
        .getDataByCondition(SQLiteDatabaseResources.tableQuizFavourite, SQLiteDatabaseResources.fieldQuizLetterUserId + " =? AND "
        + SQLiteDatabaseResources.fieldQuizLetterDisplayId + " =?", [UserMemory().firebaseUser.uid, id]);
    return list;
  }

  close(){
    _sqLiteDatabase.close();
    _sqLiteDatabase = null;
  }
}
