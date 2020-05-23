/// Author: Marcio deFreitasNascimento
/// Title: Easylist
/// Date: 05/17/2020

import 'package:easylist/DataLayer/dbpersitence.dart';
import 'databasehelper.dart';
import 'elist.dart';

class EListItem extends DBPersistence {
  int id;
  //int eListId;
  String name;
  String description;
  String imagePath;
  int status;

  EList eList;

  ///[TODO]: change to Enum
  static const STATUS_PENDING = 1;
  static const STATUS_DONE = 2;
  

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
      this.eList,
      this.name,
      this.description,
      this.imagePath,
      this.status=STATUS_PENDING});

  /// Set arguments for a constructor's calling
  ///
  /// It helps to generate objects from the database row maps
  EListItem.fromMap(Map<String, dynamic> map)
      : id = map[colId],
        eList = EList(id:map[colId]),
        name = map[colName],
        description = map[colDescription],
        imagePath = map[colImagePath],
        status = map[colStatus];

  @override
  Map<String, dynamic> toMap() {
    return {
      colId: id,
      colEListId: eList.id,
      colName: name,
      colDescription: description,
      colImagePath: imagePath,
      colStatus: status,
    };
  }

  @override
  String getTableName() {
    return table;
  }

  @override
  String getTableId() {
    return colId;
  }

  /// Save an EList
  Future<int> save() async {
    return this.id == null
        ? await DatabaseHelper.instance.insert(this)
        : await DatabaseHelper.instance.update(this);
  }

  /// Deletes an EListItem
  Future<int> delete() async {
    return await DatabaseHelper.instance.delete(this);
  }

}
