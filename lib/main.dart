/// Author: Marcio deFreitasNascimento
/// Title: Easylist - App Mock Up
/// Date: 05/17/2020

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'BLoC/elist_bloc.dart';
import 'UI/easylistapp_provider.dart';
import 'UI/home_screen.dart';
import 'UI/ui_utils.dart';

/// Runs the app async to load the camera in another thread 
Future<void> main() async {
  final appPath = await tempPath();
  final firstCamera = await _getFirstCamera();

  runApp(EasyListApp(camera: firstCamera, appPath:appPath));
}


/// EasyLisApp application class
class EasyListApp extends StatelessWidget {
  final camera;
  final appPath;

  EasyListApp({this.camera,this.appPath});

  @override
  Widget build(BuildContext context) {
    return EasyListAppProvider(
      eListBloc: EListBloc(),
      camera: camera,
      appPath: appPath,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EasyList',        
        theme: ThemeData(
          primarySwatch: Colors.red,          
        ),
        home: HomeScreen(),
      ),
    );
  }
}

///_getFirstCamera
///
///Returns the firstcamera avaiable into the device
Future<CameraDescription> _getFirstCamera() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  return cameras.first;
}
