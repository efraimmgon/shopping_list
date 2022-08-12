import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as s;
import 'package:shopping_list/models/list_items.dart';
import 'package:shopping_list/models/shopping_list.dart';

class DbHelper {
  final int version = 1;
  s.Database? db;

  Future<s.Database?> openDb() async {
    db ??= await s.openDatabase(
      path.join(await s.getDatabasesPath(), 'shopping.db'),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE lists("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "priority INTEGER)",
        );
        db.execute(
          "CREATE TABLE items("
          "id INTEGER PRIMARY KEY,"
          "idList INTEGER,"
          "name TEXT,"
          "quantity TEXT,"
          "note TEXT,"
          "FOREIGN KEY(idList) REFERENCES lists(id))",
        );
      },
      version: version,
    );
    return db;
  }

  Future testDb() async {
    db = await openDb();
    await db?.execute('INSERT INTO lists VALUES (0, "Fruit", 2)');
    await db?.execute(
        'INSERT INTO items VALUES (0, 0, "Apples", "2 kg", "better if they are green")');
    List<Map<String, Object?>>? lists =
        await db!.rawQuery('SELECT * FROM lists');
    List<Map<String, Object?>>? items =
        await db!.rawQuery('SELECT * FROM items');
    print(lists[0].toString());
    print(items[0].toString());
  }

  Future<int> insertList(ShoppingList list) async {
    int id = await db!.insert(
      'lists',
      list.toMap(),
      conflictAlgorithm: s.ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> insertItem(ListItem item) async {
    int id = await db!.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: s.ConflictAlgorithm.replace,
    );
    return id;
  }
}
