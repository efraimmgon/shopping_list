import 'package:flutter/material.dart';
import 'package:shopping_list/util/dbhelper.dart';
import 'package:shopping_list/models/shopping_list.dart';

class ShoppingListDialog {
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew) {
    DbHelper helper = DbHelper();
    helper.openDb();
    if (!isNew) {
      txtName.text = list.name;
      txtPriority.text = list.priority.toString();
    }
    return AlertDialog(
      title: Text((isNew) ? 'New shopping list' : 'Edit shopping list'),
      content: SingleChildScrollView(
        child: Column(children: [
          TextField(
            controller: txtName,
            decoration: const InputDecoration(hintText: 'Shopping List Name'),
          ),
          TextField(
            controller: txtPriority,
            decoration:
                const InputDecoration(hintText: 'Shopping List Priority'),
          ),
          ElevatedButton(
            onPressed: () {
              list.name = txtName.text;
              list.priority = int.parse(txtPriority.text);
              helper.insertList(list);
              Navigator.pop(context);
            },
            child: const Text('Save Shopping List'),
          ),
        ]),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }
}
