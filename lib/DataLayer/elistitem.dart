/// Author: Marcio deFreitasNascimento
/// Title: Easylist 
/// Date: 05/17/2020

import 'package:easylist/DataLayer/dbpersitence.dart';
import 'databasehelper.dart';

class EListItem implements IDBPersistence {
  int id;
  int eListId;
  String name;
  String description;
  String imagePath;
  int status;

  /// Table DDL
  static final table = "EListItem";
  static final elistTable = "EList";
  static final colId = "id";
  static final colEListId = "eListId";
  static final colName = "name";
  static final colDescription = "description";
  static final colImagePath = "imagePath";
  static final colStatus = "status";

  static final elistItemDDL = ''' 
    CREATE TABLE $table(
      $colId Integer NOT NULL PRIMARY KEY AUTOINCREMENT,
      $colName Text NOT NULL,
      $colDescription Text,
      $colStatus Integer NOT NULL DEFAULT 1,
      $colImagePath Text,
      $colEListId Integer,
      CONSTRAINT "lnk_EList_EListItem" FOREIGN KEY ( $colEListId ) REFERENCES $elistTable( $colId )
    ); ''';

  EListItem(
      {this.id,
      this.eListId,
      this.name,
      this.description,
      this.imagePath,
      this.status});

  /// Set arguments for a constructor's calling
  /// 
  /// It helps to generate objects from the database row maps
  EListItem.fromMap(Map<String, dynamic> map)
      : id = map[colId],
        eListId = map[colId],
        name = map[colName],
        description = map[colDescription],
        imagePath = map[colImagePath],
        status = map[colStatus];

  /// Maps to database
  Map<String, dynamic> toMap() {
    return {
      colId: id,
      colEListId: eListId,
      colName: name,
      colDescription: description,
      colImagePath: imagePath,
      colStatus: status,
    };
  }

  String getTableName() {
    return table;
  }

  String getTableId() {
    return colId;
  }

  /// Returns all ELists objects
  Future<List<EListItem>> getAllEListItems() async {
    final results = await DatabaseHelper.instance.queryAllRows(this);
    return results.map((rowMap) => EListItem.fromMap(rowMap));
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
  Future<List<EListItem>> getEListItemsByName(String name) async {
    final criteria = "$colName LIKE '%$name%'";
    final results = await DatabaseHelper.instance.queryRows(table, criteria);
    return results.map((rowMap) => EListItem.fromMap(rowMap));
  }
}
