import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseProvider {
  Database _instance;

  String get databaseName;

  String get tableName;

  int get databaseVersion;

  Future<Database> get database async {
    _instance ??= await openDatabase(
      join(
        await getDatabasesPath(),
        databaseName,
      ),
      onCreate: createDatabase,
      onUpgrade: upgradeDatabase,
      version: databaseVersion,
    );
    return _instance;
  }

  Future<void> createDatabase(Database db, int version);

  Future<void> upgradeDatabase(Database db, int oldVersion, int newVersion);
}
