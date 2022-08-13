import 'package:flutter/material.dart';
import 'package:shopping_list/models/list_items.dart';
import 'package:shopping_list/util/dbhelper.dart';

class ListItemDialog {
  final txtName = TextEditingController();
  final txtQuantity = TextEditingController();
  final txtNote = TextEditingController();

  Widget buildDialog(BuildContext context, ListItem item, bool isNew) {
    DbHelper helper = DbHelper();
    helper.openDb();
    if (!isNew) {
      txtName.text = item.name;
      txtQuantity.text = item.quantity;
      txtNote.text = item.note;
    }

    return AlertDialog(
      title: Text((isNew) ? 'New shopping item' : 'Edit shopping item'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            TextField(
              controller: txtQuantity,
              decoration: const InputDecoration(hintText: 'Quantity'),
            ),
            TextField(
              controller: txtNote,
              decoration: const InputDecoration(hintText: 'Note'),
            ),
            ElevatedButton(
              onPressed: () {
                item.name = txtName.text;
                item.quantity = txtQuantity.text;
                item.note = txtNote.text;
                helper.insertItem(item);
                Navigator.pop(context);
              },
              child: const Text('Save Item'),
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }
}
