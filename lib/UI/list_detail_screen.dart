import 'package:camera/camera.dart';
import 'package:easylist/DataLayer/elist.dart';
import 'package:easylist/DataLayer/elistitem.dart';

/// Author: Marcio deFreitasNascimento
/// Title: Easylist - App Mock Up
/// Date: 05/17/2020

import 'package:easylist/UI/picture_screen.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'easylistapp_provider.dart';
import 'list_screen.dart';
import 'ui_utils.dart';

/// ListDetailScree class
///
/// UI displays the items of a specific ListScreen
class ListDetailScreen extends StatefulWidget {
  final String imagePath;
  final EList eListParent;

  ListDetailScreen({Key key, this.title, this.imagePath, this.eListParent})
      : super(key: key);

  final String title;

  @override
  _ListDetailScreenState createState() => _ListDetailScreenState(
      title: title, imagePath: imagePath, eListParent: eListParent);
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  _ListDetailScreenState({this.title, this.imagePath, this.eListParent}) {
    this.title = this.title == null ? "List Name" : this.title;
  }

  String title;
  String imagePath;
  EList eListParent;

  /// A unique key
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final  ElistItemStatus _eListItemStatus = ElistItemStatus();

  @override
  Widget build(BuildContext context) {
    final CameraDescription camera = EasyListAppProvider.of(context).camera;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
          ),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => ListScreen())),
        ),
        title: Text(title),
      ),
      body: _allItems(context),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Spacer(flex: 50),
          FloatingActionButton(
              heroTag: "option1",
              child: Icon(Icons.add),
              onPressed: () {
                _editListItemScreen(context, EListItem(eList: eListParent));
              }),
          Spacer(flex: 1),
          FloatingActionButton(
            heroTag: "option2",
            child: Icon(Icons.add_a_photo),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => TakePictureScreen(camera: camera))),
          ),
        ],
      ),
    );
  }

  /// Displays the items of the List
  ///
  Widget _allItems(BuildContext context) {
    final eListBloc = EasyListAppProvider.of(context).eListBloc;

    /// force stream refresh
    eListBloc.eListItemSink.add(EListItem(eList: eListParent));    

    /// Toggles an item according to item status
    void _toggleStatus(EListItem item) {

      if (item.status == _eListItemStatus.STATUS_DONE) {
        item.status = _eListItemStatus.STATUS_PENDING;
        showMessageInScaffold(_scaffoldKey, "Item pending.");
      } else {
        item.status = _eListItemStatus.STATUS_DONE;
        showMessageInScaffold(_scaffoldKey, "Item done");
      }

      /// add changed elistItem to a bloc sink
      eListBloc.eListItemSink.add(item.setOperation(item.OPERATION_SAVE));
    }

    return StreamBuilder<List<EListItem>>(
        stream: eListBloc.allEListItems,
        initialData: List<EListItem>(),
        builder: (context, snapshot) {
          return ListView.separated(
            itemCount: snapshot.data.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {

             /// The ListItem color status
             EListItem _item = snapshot.data[index];
             Color _checkColor = _item.status == _eListItemStatus.STATUS_DONE
                      ? Colors.green
                      : Colors.red;                                     

              /// Delete swipe button
              ///
              return Dismissible(
                key: Key('${_item.id}'),
                onDismissed: (direction) {
                  eListBloc.eListItemSink.add(_item
                      .setOperation(_item.OPERATION_DELETE));
                  showMessageInScaffold(
                      _scaffoldKey, "{${_item.name}");
                },
                background: Container(
                  color: Colors.red,
                  child: Text('Delete',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 10.0),
                ),

                /// ElistItem Widget
                child: ListTile(
                  leading: IconButton(
                      icon: Icon(Icons.check_circle_outline),
                      color: _checkColor,
                      onPressed: () {
                        _toggleStatus(_item);
                      }),
                  title: Text('${_item.name}'),
                  trailing: (this.imagePath != null && index == 0)
                      ? IconButton(
                          icon: Image.file(File(imagePath)),
                          onPressed: () {
                            showMessageInScaffold(
                                _scaffoldKey, "TODO: image editing");
                          },
                        )
                      : IconButton(icon: Icon(Icons.photo), onPressed: () {}),
                  onTap: () {                    
                    _editListItemScreen(context, _item);
                  },
                ),
              );
            },
          );
        });
  }

  /// Provides a dialog for edit of an item
  ///
  Future<void> _editListItemScreen(
      BuildContext context, EListItem eListItem) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          final eListBloc = EasyListAppProvider.of(context).eListBloc;
          TextEditingController nameController = TextEditingController();
          nameController.text = eListItem.id == null ? "" : eListItem.name;
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
                      color: Colors.grey,
                      tooltip: 'Save Item',
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(Icons.save),
                        ],
                      ),
                      onPressed: () {
                        eListItem.name = nameController.text;

                        /// add to a bloc sink
                        ///
                        eListBloc.eListItemSink.add(
                            eListItem.setOperation(eListItem.OPERATION_SAVE));
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
                    labelText: 'Item Name',
                  ),
                ),
              ),
            ],
          );
        });
  }
}
