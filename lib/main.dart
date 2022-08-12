import 'package:flutter/material.dart';
import 'util/dbhelper.dart' as db;
import 'models/list_items.dart';
import 'models/shopping_list.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Shopping List')),
        body: ShList(),
      ),
    );
  }
}

class ShList extends StatefulWidget {
  const ShList({Key? key}) : super(key: key);

  @override
  State<ShList> createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  db.DbHelper helper = db.DbHelper();

  @override
  Widget build(BuildContext context) {
    showData();
    return Container();
  }

  Future showData() async {
    await helper.openDb();
    ShoppingList list = ShoppingList(0, 'Bakery', 2);
    int listId = await helper.insertList(list);
    ListItem item = ListItem(0, listId, 'Bread', '1 kg', 'note');
    int itemId = await helper.insertItem(item);
    print('List id: ${listId.toString()}');
    print('Item id: ${itemId.toString()}');
  }
}
