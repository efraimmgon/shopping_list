import 'package:flutter/material.dart';
import 'package:shopping_list/models/list_items.dart';
import 'package:shopping_list/models/shopping_list.dart';
import 'package:shopping_list/util/dbhelper.dart';
import 'list_item_dialog.dart';

class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;

  const ItemsScreen(
    this.shoppingList, {
    Key? key,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<ItemsScreen> createState() => _ItemsScreenState(shoppingList);
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ShoppingList shoppingList;
  late DbHelper helper;
  List<ListItem>? items;

  _ItemsScreenState(this.shoppingList);

  @override
  Widget build(BuildContext context) {
    helper = DbHelper();
    showData(shoppingList.id);
    ListItemDialog dialog = ListItemDialog();
    return Scaffold(
      appBar: AppBar(title: Text(shoppingList.name)),
      body: ListView.builder(
        itemCount: (items != null) ? items!.length : 0,
        itemBuilder: (BuildContext context, int i) {
          ListItem item = items![i];
          return Dismissible(
            key: Key(item.id.toString()),
            onDismissed: (direction) {
              String itemName = item.name;
              helper.deleteItem(item);
              setState(() {
                items!.removeAt(i);
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("$itemName deleted")));
            },
            child: ListTile(
              title: Text(item.name),
              subtitle: Text('Quantity: ${item.quantity} - Note: ${item.note}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        dialog.buildDialog(context, item, false),
                  );
                },
              ),
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
              ListItem(0, shoppingList.id, '', '', ''),
              true,
            ),
          );
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future showData(int idList) async {
    await helper.openDb();
    items = await helper.getItems(idList);
    setState(() {
      items = items;
    });
  }
}
