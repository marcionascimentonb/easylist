import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'easylistapp_provider.dart';

/// Shows the system messages through a SnackBar
///
void showMessageInScaffold(
    GlobalKey<ScaffoldState> scaffoldKey, String message) {
  scaffoldKey.currentState.showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

/// TODO: save pictures to gallery
Future<String> tempPath() async {  
  String path;
  try {
    path = join(
      // Find the temp directory using the `path_provider` plugin.
      (await getTemporaryDirectory()).path
    );    
  } catch (e) {
    // If an error occurs, log the error to the console.
    print(e);
  }
  return path;
}

/// TODO: save pictures to gallery
String picturePath(BuildContext context) {
  //final appPath = EasyListAppProvider.of(context).appPath;
  /// TODO: remove this hardcode
  String appPath="/data/user/0/com.example.easylist/cache/";
  String path;
  try {
    path = join(
      // Store the picture in the temp directory.
      // Find the temp directory using the `path_provider` plugin.
      appPath,
      '${DateTime.now()}.png',
    );
    
  } catch (e) {
    // If an error occurs, log the error to the console.
    print(e);
  }
  return path;
}