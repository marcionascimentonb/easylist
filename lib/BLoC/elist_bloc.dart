/// Author: Marcio deFreitasNascimento
/// Title: Easylist
/// Date: 05/17/2020

import 'dart:async';
import 'package:easylist/DataLayer/elist.dart';
import 'package:easylist/DataLayer/elistitem.dart';
import 'package:rxdart/rxdart.dart';
import 'blocbase.dart';

/// ElistBloc class
///
/// [TODO] immplents filter lists by criteria
class EListBloc extends BlocBase {
  final _eL = EList();

  /// Stream for get all eLists
  final _eLsController = BehaviorSubject<List<EList>>();
  Stream<List<EList>> get allELists => _eLsController.stream;
  
  /// Stream for manage an eList
  final _eListController = StreamController<EList>();
  Sink<EList> get eListSink => _eListController.sink; 

  /// Stream for get all EListItems of an EList
  final _eLItemsController = BehaviorSubject<List<EListItem>>();
  Stream<List<EListItem>> get allEListItems => _eLItemsController.stream;

  /// Stream for manage an eListItem
  final _eListItemController = StreamController<EListItem>();
  Sink<EListItem> get eListItemSink => _eListItemController.sink; 


  EListBloc() {    
    _getAllELists();
    _eListController.stream.listen(_handleElist);
    _eListItemController.stream.listen(_handleElistItem);
  }
  
  /// 
  /// #Elist methods
  /// 
  void _handleElist(EList eList) {

    if (eList.operation == eList.OPERATION_SAVE)
      eList.save();
    else if (eList.operation == eList.OPERATION_DELETE)
      eList.delete();

    //move saved list into the allElists sink
    _getAllELists();
  }

  void _getAllELists() async {
    final results = await _eL.getAllELists();
    _eLsController.sink.add(results); 
  }
  
  /// 
  /// #ElistItem methods
  /// 
  void _handleElistItem(EListItem eListItem) {
    if (eListItem.operation == eListItem.OPERATION_SAVE)
      eListItem.save();
    else if (eListItem.operation == eListItem.OPERATION_DELETE)
      eListItem.delete();
    //move saved list into the allElists sink
    _getAllEListItems(eListItem);
  }  

  void _getAllEListItems(EListItem eListItem) async {
    final results = await eListItem.eList.getAllEListItems();
    _eLItemsController.sink.add(results); 
  }  

  @override 
  void dispose() {    
    _eLsController.close();
    _eListController.close();
    _eLItemsController.close();
    _eListItemController.close();
  }
}
