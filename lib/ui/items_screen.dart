import 'package:flutter/material.dart';
import 'package:shopping_list/models/list_items.dart';
import 'package:shopping_list/models/shopping_list.dart';
import 'package:shopping_list/util/dbhelper.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text(shoppingList.name)),
      body: ListView.builder(
        itemCount: (items != null) ? items!.length : 0,
        itemBuilder: (BuildContext context, int i) {
          ListItem item = items![i];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('Quantity: ${item.quantity} - Note: ${item.note}'),
            onTap: () {},
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),
          );
        },
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
