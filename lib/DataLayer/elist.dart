/// Author: Marcio deFreitasNascimento
/// Title: Easylist 
/// Date: 05/17/2020

import 'package:easylist/DataLayer/dbpersitence.dart';
import 'databasehelper.dart';

/// EasyList definition
///
class EList implements IDBPersistence {
  final int id;
  final String name;
  final String description;

  /// Table DDL
  static final table = "EList";
  static final colId = "id";
  static final colName = "name";
  static final colDescription = "description";

  static final elistDDL = ''' 
    CREATE TABLE $table(
      $colId Integer NOT NULL PRIMARY KEY AUTOINCREMENT,
      $colName Text NOT NULL,
      $colDescription Text );''';

  EList({this.id, this.name, this.description});

  /// Set arguments for a constructor's calling
  /// 
  /// It helps to generate objects from the database row maps
  EList.fromMap(Map<String, dynamic> map)
      : id = map[colId],
        name = map[colName],
        description = map[colDescription];

  /// Maps to database
  Map<String, dynamic> toMap() {
    return {
      colId: id,
      colName: name,
      colDescription: description,
    };
  }

  String getTableName() {
    return table;
  }

  String getTableId() {
    return colId;
  }

  /// Returns all ELists objects
  Future<List<EList>> getAllELists() async {
    final results =  await DatabaseHelper.instance.queryAllRows(this);
    return results.map((rowMap) => EList.fromMap(rowMap));
  }

  /// Inserts an EList
  Future<int> insert() async {
    return await DatabaseHelper.instance.insert(this);    
  }

  /// Updates an EList
  Future<int> update() async {
    return await DatabaseHelper.instance.update(this);    
  }

  /// Deletes an EList
  Future<int> delete() async {
    return await DatabaseHelper.instance.delete(this);    
  }

  /// Get ELists by approximate name
  Future<List<EList>> getEListsByName(String name) async {
    final criteria = "$colName LIKE '%$name%'";
    final results =  await DatabaseHelper.instance.queryRows(table,criteria);
    return results.map((rowMap) => EList.fromMap(rowMap));
  }

}
