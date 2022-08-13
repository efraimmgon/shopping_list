import 'package:flutter/material.dart';
import 'util/dbhelper.dart' as db;
import 'models/shopping_list.dart';
import 'ui/items_screen.dart';
import 'package:shopping_list/ui/shopping_list_dialog.dart';

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
      home: const ShList(),
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
  late ShoppingListDialog dialog;

  @override
  void initState() {
    dialog = ShoppingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: ListView.builder(
        itemCount: (shoppingList != null) ? shoppingList!.length : 0,
        itemBuilder: (BuildContext context, int index) {
          ShoppingList sl = shoppingList![index];
          return Dismissible(
            key: Key(sl.id.toString()),
            onDismissed: (direction) {
              String strName = sl.name;
              helper.deleteList(sl);
              setState(() {
                shoppingList!.removeAt(index);
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("$strName deleted")));
            },
            child: ListTile(
              leading: CircleAvatar(
                child: Text(sl.priority.toString()),
              ),
              title: Text(sl.name),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          dialog.buildDialog(context, sl, false));
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemsScreen(shoppingList![index]),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => dialog.buildDialog(
              context,
              ShoppingList(0, '', 0),
              true,
            ),
          );
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
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
