import 'package:flutter/material.dart';

import 'UI/home_screen.dart';

void main() {
  runApp(EasyListApp());
}

class EasyListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyList',
      theme: ThemeData(
        primarySwatch: Colors.red,                
      ),
      home: HomeScreen(),
    );
  }
}

