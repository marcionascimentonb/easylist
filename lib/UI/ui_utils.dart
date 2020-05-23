  import 'package:flutter/material.dart';

/// Shows the system messages through a SnackBar
  ///
  void showMessageInScaffold(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }