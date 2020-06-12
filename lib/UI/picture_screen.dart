/// Author: https://flutter.dev/docs/cookbook/plugins/picture-using-camera#complete-example
/// Modifications by: Marcio de Freitas Nascimento
/// Title: Easylist

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:easylist/DataLayer/dbpersitence.dart';
import 'package:easylist/DataLayer/elistitem.dart';
import 'package:easylist/UI/easylistapp_provider.dart';
import 'package:easylist/UI/list_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  /// Object from dataLayer which will persist the picture
  final DBPersistence dataObject;

  const TakePictureScreen(
      {Key key, @required this.camera, @required this.dataObject})
      : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  (widget.dataObject as EListItem).imagePath = path;
                  dispose();
                  return DisplayPictureScreen(dataObject: widget.dataObject);
                },
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final DBPersistence dataObject;

  const DisplayPictureScreen({Key key, this.dataObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eListBloc = EasyListAppProvider.of(context).eListBloc;

    return Scaffold(
      appBar: AppBar(
        title:
            /// ?? test with the name is null first 
            /// and if true give a default text instead
            Text((dataObject as EListItem).name ?? 'Picture of the New Item'),
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File((dataObject as EListItem).imagePath)),
      floatingActionButton: FloatingActionButton(
        child: Text("Save"),
        tooltip: 'Save Item Picture',
        onPressed: () {
          if ((dataObject as EListItem).id != null)
            // add changed elistItem to a bloc sink
            eListBloc.eListItemSink
                .add(dataObject.setOperation(dataObject.OPERATION_SAVE));

          Navigator.of(context).push(
            MaterialPageRoute(
              /// Going back to the List Items
              builder: (_) => ListDetailScreen(
                  eListParent: (dataObject as EListItem).eList,
                  currentItem: (dataObject as EListItem)),
            ),
          );
        },
      ),
    );
  }
}
