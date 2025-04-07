import 'dart:async';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'model/photo.dart';

class DBHelper {
  static Database? _db;

  static const String ID = 'id';
  static const String NAME = 'photoName';
  static const String TITLE = 'title';
  static const String DESCRIPTION = 'description';
  static const String TABLE_NAME = 'photoTable';
  static const String DB_NAME = 'flutter.db';

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    io.Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, DB_NAME);

    return await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $TABLE_NAME (
            $ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $NAME TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (Database db, oldVersion, newVersion) async {
        await db.execute("DROP TABLE IF EXISTS $TABLE_NAME");
        await db.execute('''
      CREATE TABLE $TABLE_NAME (
        $ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $NAME TEXT NOT NULL,
        $TITLE text not null,
        $DESCRIPTION text not null
      )
    ''');
      },
    );
  }

  Future<int> insertPhoto(Photo photo) async {
    try {
      final db = await database;
      return await db.insert(TABLE_NAME, photo.toMap());
    } catch (e) {
      print('\n\n\ninsertPhoto: ${e.toString()}');
      Get.snackbar('Error', e.toString());
      return 0;
    }
  }

  Future<List<Photo>> getPhotos() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query(TABLE_NAME);
      return result.map((e) => Photo.fromMap(e)).toList();
    } catch (e) {
      print('\n\n\ngetPhoto: ${e.toString()}');
      Get.snackbar('Error', e.toString());
      return [];
    }
  }
}
