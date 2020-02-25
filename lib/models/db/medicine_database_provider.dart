import 'package:sqflite/sqflite.dart';

import '../medicine.dart';
import 'database_provider.dart';

class MedicineDatabaseProvider extends DatabaseProvider {
  @override
  String get databaseName => 'sample.db';

  @override
  String get tableName => 'medicines';

  @override
  int get databaseVersion => 1;

  @override
  Future<void> createDatabase(Database db, int version) => db.execute(
        '''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            gs1code TEXT,
            medicineName TEXT,
            docType TEXT,
            url TEXT,
            favorite INTEGER
          )
        ''',
      );

  @override
  Future<void> upgradeDatabase(
      Database db, int oldVersion, int newVersion) async {
    for (var i = oldVersion + 1; i <= newVersion; i++) {
//      var queries = scripts[i.toString()];
//      for (String query in queries) {
//        await db.execute(query);
//      }
    }
  }

  Future<int> insertMedicine(Medicine medicine) async {
    final Database db = await database;
    return await db.insert(
      tableName,
      medicine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Medicine>> getMedicineAll() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Medicine(
//        id: maps[i]['id'],
          maps[i]['gs1code'] as String,
          maps[i]['medicineName'] as String,
          maps[i]['docType'] as String,
          maps[i]['url'] as String,
          maps[i]['favorite'] == 0);
    });
  }

  Future<Medicine> getMedicine(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> medicines =
        await db.query(tableName, where: 'id = ?', whereArgs: <dynamic>[id]);
    var resMedicine = List.generate(medicines.length, (i) {
      return Medicine(
//        id: maps[i]['id'],
          medicines[i]['gs1code'] as String,
          medicines[i]['medicineName'] as String,
          medicines[i]['docType'] as String,
          medicines[i]['url'] as String,
          medicines[i]['favorite'] == 0);
    });
    return resMedicine[0];
  }
}
