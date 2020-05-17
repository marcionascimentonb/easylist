/// Author: Marcio deFreitasNascimento
/// Title: Easylist - App Mock Up
/// Date: 05/17/2020

import 'package:flutter/material.dart';
import 'list_screen.dart';

/// HomeScreen class
class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  
  final String title;
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListScreen();
  }
}