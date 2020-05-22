/// Author: Marcio deFreitasNascimento
/// Title: Easylist 
/// Date: 05/17/2020
/// Author: Marcio deFreitasNascimento
/// Title: Easylist
/// Date: 05/17/2020

import 'dart:async';
import 'package:easylist/DataLayer/elistitem.dart';
import 'blocbase.dart';

/// ElistBloc class
///
/// [TODO] immplents filter lists by criteria
class EListItemBloc extends BlocBase {
  final _eListItem = EListItem();

  final _eListItemsController = StreamController<List<EListItem>>();

  Stream<List<EListItem>> get stream => _eListItemsController.stream;

  EListItemBloc() {
    //_elistsController.stream.listen(_handle);
  }

  // void _handle(List<EList> event) {
  //   _elistsController.sink.add()
  // }

  /// My sink is exposed by this method
  void getAllELists() async {
    final results = await _eListItem.getAllEListItems();
    _eListItemsController.sink.add(results);
  }

  @override
  void dispose() {}
}
