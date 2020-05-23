  import 'package:flutter/material.dart';

/// Shows the system messages through a SnackBar
  ///
  void showMessageInScaffold(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
