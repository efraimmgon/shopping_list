import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as s;

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
}
