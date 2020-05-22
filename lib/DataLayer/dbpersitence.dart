/// Author: Marcio deFreitasNascimento
/// Title: Easylist 
/// Date: 05/17/2020

/// Persistence definition for database use. 
/// 
/// The idea here is to use this class as an interface and
/// to have others interfaces of different kinds of persistence
class IDBPersistence{

  /// database table name
  String getTableName(){}

  String getTableId(){}

  /// Map used in CRUD operations
  Map<String, dynamic> toMap(){}
}