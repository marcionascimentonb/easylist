import 'package:easylist/DataLayer/elist.dart';
import 'package:easylist/UI/easylistapp_provider.dart';

/// Author: Marcio deFreitasNascimento
/// Title: Easylist
/// Date: 05/17/2020

import 'package:easylist/UI/list_detail_screen.dart';
import 'package:easylist/UI/ui_utils.dart';
import 'package:flutter/material.dart';

/// ListScreen Class
///
/// UI that allows to manage the avaiables lists
class ListScreen extends StatelessWidget {
  const ListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('images/easylist_icon.png'),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => ListScreen())),
        ),
        title: Text("EasyList - All lists"),
      ),
      body: _allLists(context, _scaffoldKey),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _editListScreen(context, EList());
          }),
    );
  }

  /// Returns all avaiable lists
  Widget _allLists(BuildContext context, GlobalKey<ScaffoldState> scaffoldkey) {
    final eListBloc = EasyListAppProvider.of(context).eListBloc;
    return StreamBuilder<List<EList>>(
        stream: eListBloc.allELists,
        initialData: List<EList>(),
        builder: (context, snapshot) {
          return ListView.separated(
            itemCount: snapshot.data.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              /// Delete swipe button
              ///
              return Dismissible(
                key: Key('${snapshot.data[index].id}'),
                onDismissed: (direction) {
                  eListBloc.eListSink.add(snapshot.data[index]
                      .setOperation(snapshot.data[index].OPERATION_DELETE));
                  showMessageInScaffold(
                      scaffoldkey, "${snapshot.data[index].name} deleted.");
                },
                background: Container(
                  color: Colors.red,
                  child: Text('Delete',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 10.0),
                ),

                /// EList Widget
                ///
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(
                      Icons.edit,
                    ),
                    onPressed: () =>
                        _editListScreen(context, snapshot.data[index]),
                  ),
                  title: Text('${snapshot.data[index].name}'),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          ListDetailScreen(eListParent: snapshot.data[index]))),
                ),
              );
            },
          );
        });
  }

  /// Provides a dialog for edit of a list
  ///
  Future<void> _editListScreen(BuildContext context, EList eList) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          final eListBloc = EasyListAppProvider.of(context).eListBloc;
          TextEditingController nameController = TextEditingController();
          nameController.text = eList.id == null ? "" : eList.name;
          return SimpleDialog(
            contentPadding: EdgeInsets.all(0.0),
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.close,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    FlatButton(
                      child: Text("Save list"),                      
                      onPressed: () {
                        eList.name = nameController.text;
                        /// add to a bloc sink
                        eListBloc.eListSink
                            .add(eList.setOperation(eList.OPERATION_SAVE));
                        nameController.text = "";
                      },
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                child: Divider(),
                padding: EdgeInsets.all(0.0),
              ),
              SimpleDialogOption(
                child: TextField(
                  controller: nameController,
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
