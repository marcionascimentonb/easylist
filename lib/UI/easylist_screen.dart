import 'package:flutter/material.dart';

class EasyListScreen extends StatelessWidget {
  const EasyListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All lists"),
      ),
      body: _allLists(context),      
    );
  }

  Widget _allLists(BuildContext context){
    return ListView.separated(
      /// [TODO]: load dynamically
      /// https://flutter.dev/docs/cookbook/lists/basic-list
      itemCount: 4, 
      separatorBuilder: (context,index) => Divider(),
      itemBuilder: (context,index){
        return ListTile(
          leading: Icon(Icons.list),
          title:Text('List $index'),
        );
      },  
      );
  }
}

