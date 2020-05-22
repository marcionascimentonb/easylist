/// Author: Marcio deFreitasNascimento
/// Title: Easylist - App Mock Up
/// Date: 05/17/2020

import 'package:easylist/UI/picture_screen.dart';
import 'package:easylist/main.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'list_screen.dart';

/// ListDetailScree class
///
/// UI displays the items of a specific ListScreen
class ListDetailScreen extends StatefulWidget {
  final String imagePath;

  ListDetailScreen({Key key, this.title, this.imagePath}) : super(key: key);

  final String title;

  @override
  _ListDetailScreenState createState() =>
      _ListDetailScreenState(title: title, imagePath: imagePath);
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  _ListDetailScreenState({this.title, this.imagePath}) {
    this.title = this.title == null ? "List Name" : this.title;
  }

  String title;
  String imagePath;
  Color _checkColor = Colors.red;
  List<MaterialColor> _checkColors = List<MaterialColor>();

  /// A unique key across the entire app
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final InheritedCamera inheritedCamera =
        context.inheritFromWidgetOfExactType(InheritedCamera);
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
                _addListItemScreen(context);
              }),
          Spacer(flex: 1),
          FloatingActionButton(
            heroTag: "option2",
            child: Icon(Icons.add_a_photo),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) =>
                    TakePictureScreen(camera: inheritedCamera.camera))),
          ),
        ],
      ),
    );
  }

  /// Displays the items of the List
  ///
  Widget _allItems(BuildContext context) {
    return ListView.separated(
      /// [TODO]: load dynamically
      /// https://flutter.dev/docs/cookbook/lists/basic-list
      itemCount: 3,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        _checkColors.add(_checkColor);
        return ListTile(
          leading: IconButton(
              icon: Icon(Icons.check_circle_outline),
              color: _checkColors[index],
              onPressed: () {
                setState(() {
                  _toggleItem(_checkColors[index], index);
                });
              }),
          title: Text('Item ${index + 1}'),
          trailing: (this.imagePath != null && index == 0)
              ? IconButton(
                  icon: Image.file(File(imagePath)),
                  onPressed: () {
                    _showMessageInScaffold("TODO: image editing");
                  },
                )
              : IconButton(icon: Icon(Icons.photo), onPressed: () {}),
        );
      },
    );
  }

  /// Shows the system messages through a SnackBar
  ///
  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  /// Toggles an item between [Pending] and [Done] item status
  void _toggleItem(Color color, index) {
    if (color == Colors.green) {
      _checkColors[index] = Colors.red;
      _showMessageInScaffold("Item pending.");
    } else {
      _checkColors[index] = Colors.green;
      _showMessageInScaffold("Item done");
    }
  }

  /// Provides a dialog for adding of a new item
  ///
  Future<void> _addListItemScreen(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
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
                      onPressed: () {},
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
