/// Author: Marcio deFreitasNascimento
/// Title: Easylist
/// Date: 05/17/2020

import 'dart:async';
import 'package:easylist/DataLayer/elist.dart';
import 'blocbase.dart';

/// ElistBloc class
///
/// [TODO] immplents filter lists by criteria
class EListBloc extends BlocBase {
  final _eList = EList();

  final _eListsController = StreamController<List<EList>>();

  Stream<List<EList>> get stream => _eListsController.stream;

  EListBloc() {
    //_elistsController.stream.listen(_handle);
  }

  // void _handle(List<EList> event) {
  //   _elistsController.sink.add()
  // }

  /// My sink is exposed by this method
  void getAllELists() async {
    final results = await _eList.getAllELists();
    _eListsController.sink.add(results);
  }

  @override
  void dispose() {}
}
