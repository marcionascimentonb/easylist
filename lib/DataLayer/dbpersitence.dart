/// Author: Marcio deFreitasNascimento
/// Title: Easylist 
/// Date: 05/17/2020

/// Persistence definition for database use. 
/// 
abstract class DBPersistence{

  /// TODO: change to enum
  final int OPERATION_SAVE = 1;
  final int OPERATION_DELETE = 2;
  int operation; 



  DBPersistence setOperation(int operation) {
    this.operation =  operation;
    return this;
  }

  /// database table name
  String getTableName();

  String getTableId();

  /// Map used in CRUD operations
  Map<String, dynamic> toMap();
}