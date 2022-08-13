import 'package:flutter/material.dart';
import 'util/dbhelper.dart' as db;
import 'models/list_items.dart';
import 'models/shopping_list.dart';
import 'ui/items_screen.dart';

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
        appBar: AppBar(title: const Text('Shopping List')),
        body: const ShList(),
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
  List<ShoppingList>? shoppingList;

  @override
  Widget build(BuildContext context) {
    showData();
    return ListView.builder(
      itemCount: (shoppingList != null) ? shoppingList!.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(shoppingList![index].name),
          leading: CircleAvatar(
            child: Text(shoppingList![index].priority.toString()),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemsScreen(shoppingList![index]),
              ),
            );
          },
        );
      },
    );
  }

  Future showData() async {
    await helper.openDb();
    shoppingList = await helper.getLists();
    setState(() {
      shoppingList = shoppingList;
    });
  }
}
