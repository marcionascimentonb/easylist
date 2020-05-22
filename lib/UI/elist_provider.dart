import 'package:flutter/widgets.dart';


/// The EListProvider class
/// 
/// Allows to call the it's attributes down into the widgets tree
class EListProvider extends InheritedWidget {
  final camera;
  final eListBloc;

  EListProvider({this.camera,this.eListBloc, Key key, this.child})
      : super(key: key, child: child);

  final Widget child;

  static EListProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType() as EListProvider);
  }

  @override
  bool updateShouldNotify(EListProvider oldWidget) {
    return true;
  }
}