/// Author: Marcio deFreitasNascimento
/// Title: Easylist
/// Date: 05/17/2020

import 'dart:async';
import 'package:easylist/DataLayer/elist.dart';
import 'package:rxdart/rxdart.dart';
import 'blocbase.dart';

/// ElistBloc class
///
/// [TODO] immplents filter lists by criteria
class EListBloc extends BlocBase {
  final _eL = EList();

  final _eLsController = BehaviorSubject<List<EList>>();
  Stream<List<EList>> get allELists => _eLsController.stream;
  

  final _eListController = StreamController<EList>();
  Sink<EList> get eListSave => _eListController.sink; 



  EListBloc() {    
    _getAllELists();
    _eListController.stream.listen(_handle);
  }

  void _handle(EList eList) {
    eList.save();
    //move saved list into the allElists sink
    _getAllELists();
  }

  /// My sink is exposed by this method
  void _getAllELists() async {
    final results = await _eL.getAllELists();
    _eLsController.sink.add(results); 
  }

  @override
  void dispose() {}
}
