/// Author: Marcio deFreitasNascimento
/// Title: Easylist - App Mock Up
/// Date: 05/17/2020

import 'package:easylist/UI/list_detail_screen.dart';
import 'package:flutter/material.dart';

/// ListScreen Class
///
/// UI that allows to manage the avaiables lists
class ListScreen extends StatelessWidget {
  const ListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EasyList - All lists"),
      ),
      body: _allLists(context),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _addListScreen(context);
          }),
    );
  }

  /// Returns all avaiable lists
  Widget _allLists(BuildContext context) {
    return ListView.separated(
      /// [TODO]: load dynamically
      /// https://flutter.dev/docs/cookbook/lists/basic-list
      itemCount: 4,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.list),
          title: Text('List ${index + 1}'),
        );
      },
    );
  }

  /// Provides a dialog for adding of a new list
  /// 
  Future<void> _addListScreen(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(0.0),
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(0.0),
                child: IconButton(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("Items"),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ListDetailScreen(title: "List Name"))),
                ),
              ),
              SimpleDialogOption(
                child: Divider(),
                padding: EdgeInsets.all(0.0),
              ),
              SimpleDialogOption(
                child: TextField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'List Name',
                  ),
                ),
              ),
            ],
          );
        });
  }
}