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
  _ListDetailScreenState createState() =>
      _ListDetailScreenState(title: title, imagePath: imagePath, eListParent: eListParent);
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  _ListDetailScreenState({this.title, this.imagePath, this.eListParent}) {
    this.title = this.title == null ? "List Name" : this.title;
  }

  String title;
  String imagePath;
  EList eListParent;

  Color _checkColor = Colors.red;
  List<MaterialColor> _checkColors = List<MaterialColor>();

  /// A unique key across the entire app
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

    /// Toggles an item according to item status
    void _toggleItem(Color color, int index, EListItem item) {
      if (color == Colors.green) {
        item.status = EListItem.STATUS_PENDING;
        _checkColors[index] = Colors.red;
        showMessageInScaffold(context, "Item pending.");
      } else {
        item.status = EListItem.STATUS_DONE;
        _checkColors[index] = Colors.green;
        showMessageInScaffold(context, "Item done");
      }

      /// add to a bloc sink
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
              _checkColors.add(_checkColor);

              /// Delete swipe button
              ///
              return Dismissible(
                key: Key('${snapshot.data[index].id}'),
                onDismissed: (direction) {
                  eListBloc.eListItemSink.add(snapshot.data[index]
                      .setOperation(snapshot.data[index].OPERATION_DELETE));
                  showMessageInScaffold(
                      context, "{${snapshot.data[index].name}");
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
                      color: _checkColors[index],
                      onPressed: () {
                        _toggleItem(
                            _checkColors[index], index, snapshot.data[index]);
                      }),
                  title: Text('${snapshot.data[index].name}'),
                  trailing: (this.imagePath != null && index == 0)
                      ? IconButton(
                          icon: Image.file(File(imagePath)),
                          onPressed: () {
                            showMessageInScaffold(
                                context, "TODO: image editing");
                          },
                        )
                      : IconButton(icon: Icon(Icons.photo), onPressed: () {}),
                  onTap: () =>
                      _editListItemScreen(context, snapshot.data[index]),
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
