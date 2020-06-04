import 'package:flutter/widgets.dart';


/// The EasyListAppProvider class
/// 
/// Allows to call the it's attributes down into the widgets tree
class EasyListAppProvider extends InheritedWidget {
  final camera;
  final eListBloc;
  final appPath;

  EasyListAppProvider({this.camera,this.eListBloc,this.appPath, Key key, this.child})
      : super(key: key, child: child);

  final Widget child;

  static EasyListAppProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(EasyListAppProvider) as EasyListAppProvider);
  }

  @override
  bool updateShouldNotify(EasyListAppProvider oldWidget) {
    return true;
  }
}
