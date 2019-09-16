import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

/// Class for handling all sqlite database operations
class SQLiteDb<I> {
  Database _database;

  bool setUp = false;
  String _databaseName;
  int _version;

  Function _onCreateDatabase;
  Function _onUpgradeDatabase;

  SQLiteDb(this._databaseName, this._onCreateDatabase,
      this._onUpgradeDatabase, this._version);

  ///Initialize database
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    _database = await openDatabase(path,
        version: _version,
        onOpen: (db) {},
        onCreate: _onCreateDatabase,
        onUpgrade: _onUpgradeDatabase)
        .catchError((error) {
    });

    _database.getVersion().then((value) {
      setUp = true;
    });
  }

  /// Insert database
  Future<int> createData(String tableName, Map map) async {
    try{
      var res = await _database.insert(tableName, map);
      return res;
    }
    catch(error){}

  }

  /// Get data by conditions
  getDataByCondition(String tableName, String whereCondition, List whereArgs) async {
    try{
      var res = await _database
          .query(tableName, where: whereCondition, whereArgs: whereArgs);
      return res;
    }
    catch(error){}

  }

  /// Get all data from the database table
  getAllData(String tableName, String whereCondition, String whereArgs) async {
    try{
      var res = await _database
          .query(tableName, where: whereCondition, whereArgs: [whereArgs]);
      return res;
    }
    catch(error){}
  }

  /// Update data on the table
  Future<int> updateData(String tableName, Map map, String whereCondition,
      String whereArgs) async {
    try{
      var res = await _database.update(tableName, map, where: whereCondition, whereArgs: [whereArgs]);
      return res;
    }
    catch(error){}
  }

  /// Delete data from the table
  Future<int> deleteData(
      String tableName, String whereCondition, var argList) async {
    try{
      var res = await _database.delete(tableName,
          where: whereCondition, whereArgs: argList);
      return res;
    }
    catch(error){}
  }

  /// Create data by using raw query
  Future<int> createDataRaw(String query, List values) async {
    int id1;
    try{
    ;
      await _database.transaction((txn) async {
        id1 = await txn.rawInsert(query, values);
      });
    }
    catch(error){}

    return id1;
  }

  /// Get data using raw query
  Future<List<Map>> getDataRaw (String query) async {
    try{
      List<Map> list = await _database.rawQuery(query);
      return list;
    }
    catch(error){}
  }

  /// Update data raw
  updateDataRaw(String query, List newValue) async{
    try{
      // Update some record
      int count = await _database.rawUpdate(
          query, newValue);
      return count;
    }
    catch(error){}
  }

  close(){
    _database.close();
  }
}
