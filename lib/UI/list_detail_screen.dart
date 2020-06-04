/// Author: Marcio deFreitasNascimento
/// Title: Easylist - App Mock Up
/// Date: 05/17/2020
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:easylist/DataLayer/elist.dart';
import 'package:easylist/DataLayer/elistitem.dart';
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
  final EList eListParent;
  final EListItem currentItem;

  ListDetailScreen({Key key, @required this.eListParent, this.currentItem})
      : super(key: key);

  @override
  _ListDetailScreenState createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  /// A unique key
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ElistItemStatus _eListItemStatus = ElistItemStatus();

  @override
  void initState() {
    super.initState();

    /// in case to create a new item through taking picture first
    if (widget.currentItem != null && widget.currentItem.id == null) {
      /// The timer here is to excute async _editListItemScreen
      Timer.run(() => _editListItemScreen(context, widget.currentItem));
    }
  }

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

        /// check the name of listparent for null
        /// we could use: Text(widget.eListParent.name ?? "default list name")
        title: Text(widget.eListParent.name),
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
                _editListItemScreen(
                    context, EListItem(eList: widget.eListParent));
              }),
          Spacer(flex: 1),
          FloatingActionButton(
            heroTag: "option2",
            child: Icon(Icons.add_a_photo),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                /// Take a picture and add to a new ListItem
                ///
                builder: (_) => TakePictureScreen(
                    camera: camera,
                    dataObject: EListItem(eList: widget.eListParent)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Displays the items of the List
  ///
  Widget _allItems(BuildContext context) {
    final eListBloc = EasyListAppProvider.of(context).eListBloc;
    final camera = EasyListAppProvider.of(context).camera;

    /// force stream refresh
    eListBloc.eListItemSink.add(EListItem(eList: widget.eListParent));

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
              /// Iniatializing eListItem values
              /// TODO: Change to a funtion
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
                  eListBloc.eListItemSink
                      .add(_item.setOperation(_item.OPERATION_DELETE));
                  showMessageInScaffold(_scaffoldKey, "${_item.name} deleted.");
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
                  trailing: IconButton(
                    icon: _item.imagePath != null
                        ? Image.file(File(_item.imagePath))
                        : Icon(Icons.photo),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) { 
                            /// loading a full listParent
                            /// cause an item just load its idListParent
                            /// from scratch - lazy approach
                            _item.eList = widget.eListParent;
                            return _item.imagePath != null
                              ? DisplayPictureScreen(dataObject: _item)
                              : TakePictureScreen(
                                  camera: camera, dataObject: _item);},
                        ),
                      );
                    },
                  ),
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
