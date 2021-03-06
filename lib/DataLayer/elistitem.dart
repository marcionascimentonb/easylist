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
  String quantity;

  EList eList;

  /// Table DDL
  static final table = "EListItem";
  static final elistTable = "EList";
  static final colId = "id";
  static final colEListId = "eListId";
  static final colName = "name";
  static final colDescription = "description";
  static final colImagePath = "imagePath";
  static final colStatus = "status";
  static final colQuantity = "quantity";

  static final elistItemDDL = ''' 
    CREATE TABLE $table(
      $colId Integer NOT NULL PRIMARY KEY AUTOINCREMENT,
      $colName Text NOT NULL,
      $colDescription Text,
      $colStatus Integer NOT NULL DEFAULT 1,
      $colImagePath Text,
      $colQuantity Text,
      $colEListId Integer,
      CONSTRAINT "lnk_EList_EListItem" FOREIGN KEY ( $colEListId ) REFERENCES $elistTable( $colId )
      ON DELETE CASCADE
    ); ''';

  EListItem(
      {this.id,
      this.eList,
      this.name,
      this.description,
      this.imagePath,
      ///TODO: change status value to Enum
      this.status=1,
      this.quantity});

  /// Set arguments for a constructor's calling
  ///
  /// It helps to generate objects from the database row maps
  EListItem.fromMap(Map<String, dynamic> map)
      : id = map[colId],
        eList = EList(id:map[colEListId]),
        name = map[colName],
        description = map[colDescription],
        imagePath = map[colImagePath],
        status = map[colStatus],
        quantity = map[colQuantity];

  @override
  Map<String, dynamic> toMap() {
    return {
      colId: id,
      colEListId: eList.id,
      colName: name,
      colDescription: description,
      colImagePath: imagePath,
      colStatus: status,
      colQuantity: quantity,
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

/// TODO: ElistItemStatus: change to Enum
class ElistItemStatus{
  final STATUS_PENDING=1;
  final STATUS_DONE=2;
}