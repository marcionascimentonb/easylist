import 'package:easylist/DataLayer/elist.dart';
import 'package:easylist/UI/easylistapp_provider.dart';

/// Author: Marcio deFreitasNascimento
/// Title: Easylist
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
        leading: IconButton(
          icon: Image.asset('images/easylist_icon.png'),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => ListScreen())),
        ),
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
    final eListBloc = EasyListAppProvider.of(context).eListBloc;
    return StreamBuilder<List<EList>>(
        stream: eListBloc.allELists,
        initialData: List<EList>(),
        builder: (context, snapshot) {
          return ListView.separated(
            /// [TODO]: load dynamically
            /// https://flutter.dev/docs/cookbook/lists/basic-list
            itemCount: snapshot.data.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.list),
                title: Text('${snapshot.data[index].name}'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ListDetailScreen(
                        title: '${snapshot.data[index].name}'))),
              );
            },
          );
        });
  }

  /// Provides a dialog for adding of a new list
  ///
  Future<void> _addListScreen(BuildContext context) async {
    await showDialog(      
        context: context,
        builder: (BuildContext context) {          
          final eListBloc = EasyListAppProvider.of(context).eListBloc;
          TextEditingController nameController = TextEditingController();
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
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      tooltip: 'List Items',
                      onPressed: () => eListBloc.eListSave.add(EList(name:nameController.text))
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (_) {
                            
                      //       ///[TODO]:ListDetailScreen(title: "List Name");
                      //       },
                      //   ),
                      // ),
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
