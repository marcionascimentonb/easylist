/// Author: Marcio deFreitasNascimento
/// Title: Easylist 
/// Date: 05/17/2020

import 'dart:io';

import 'package:easylist/DataLayer/dbpersitence.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:easylist/DataLayer/elist.dart';

import 'elistitem.dart';

/// A helper for database persistence
class DatabaseHelper {
  static final _databaseName = 'dbDemo.db';
  static final _databaseVersion = 1;

  /// Makes this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  /// Opens the database
  ///
  /// And Creates it if does not exist
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    print(path);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  /// The database
  static Database _database;

  /// Returns the database
  Future<Database> get database async {
    if (_database != null) return _database;

    /// lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  /// Creates database [tables] using a sql code
  Future _onCreate(Database db, int version) async {
    await db.execute(EList.elistDDL + EListItem.elistItemDDL);
  }

  /// DML methods
  ///Those methods support any object that implements dbPersistence interface

  /// Inserts Elist
  ///
  /// Returns [id] of the inserted object into a table
  Future<int> insert(IDBPersistence dbPersistence) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.insert(dbPersistence.getTableName(), dbPersistence.toMap());
  }

  /// Returns All rows of a table 
  Future<List<Map<String, dynamic>>> queryAllRows(IDBPersistence dbPersistence) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.query(dbPersistence.getTableName());
  }

  /// Retrieves rows by criteria
  ///
  /// [criteria] is a string that defines a where clause in a sql statement 
  Future<List<Map<String, dynamic>>> queryRows(String tablename, String criteria) async {
    Database db = await instance.database;
    return await db.query(tablename, where: criteria);
  }

  /// We are assuming that the id column in the map is set.
  /// The other column values will be used to update.
  Future<int> update(IDBPersistence dbPersistence) async {
    Database db = await instance.database;
    int idToUpdate = dbPersistence.toMap()[dbPersistence.getTableId()];
    return await db.update(dbPersistence.getTableName(), dbPersistence.toMap(),
        where: '${dbPersistence.getTableId()} = ?', whereArgs: [idToUpdate]);
  }

  ///Deletes row base on id, returns the affected row [id]
  Future<int> delete(IDBPersistence dbPersistence) async {
    Database db = await instance.database;
    int idToDelete = dbPersistence.toMap()[dbPersistence.getTableId()];
    return await db.delete(dbPersistence.getTableName(), where: '${dbPersistence.getTableId()} = ?', whereArgs: [idToDelete]);
  }

}
