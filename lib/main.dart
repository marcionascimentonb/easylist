import 'package:camera/camera.dart';

import 'package:flutter/material.dart';

import 'UI/home_screen.dart';

Future<void> main() async {
  final firstCamera = await getFirstCamera();

  runApp(EasyListApp(camera: firstCamera));
}

class InheritedCamera extends InheritedWidget {
  final camera;

  InheritedCamera({this.camera, Key key, this.child})
      : super(key: key, child: child);

  final Widget child;

  static InheritedCamera of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType() as InheritedCamera);
  }

  @override
  bool updateShouldNotify(InheritedCamera oldWidget) {
    return true;
  }
}

class EasyListApp extends StatelessWidget {
  final camera;

  EasyListApp({this.camera});

  @override
  Widget build(BuildContext context) {
    return InheritedCamera(
      camera: camera,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EasyList',        
        theme: ThemeData(
          primarySwatch: Colors.red,          
        ),
        home: HomeScreen(),
      ),
    );

    // return MaterialApp(

    //   debugShowCheckedModeBanner: false,
    //   title: 'EasyList',
    //   theme: ThemeData(
    //     primarySwatch: Colors.red,
    //   ),
    //   home: HomeScreen(),
    // );
  }
}

Future<CameraDescription> getFirstCamera() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  return cameras.first;
}
