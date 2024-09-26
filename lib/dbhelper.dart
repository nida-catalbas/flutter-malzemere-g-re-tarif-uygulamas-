// malzemelere göre tarif bulma, tarifi getirme
import 'dart:async';
import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:tarifuygulama/dbhelper.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'models/ingredient.dart';
import 'models/ingredients.dart';
import 'models/malzeme.dart';
import 'models/recipe.dart';



class DatabaseHelper {
  static const _databaseName = 'tarif.db';
  static const _databaseVersion = 2;

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  factory DatabaseHelper() => instance;

  DatabaseHelper._internal();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    print('get database çalıştı');
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    print('initdatabase çalıştı');
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, _databaseName);
    var exists = await databaseExists(path);
    if (!exists) {
      print('database yok kopyalanacak');
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(url.join("assets", "tarif.db"));
      List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("var olan database açılıyor");
    }
    return await openDatabase(path);
  }
  Future<Database> freshDatabase() async{
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, _databaseName);
    await Directory(dirname(path)).create(recursive: true);
    ByteData data = await rootBundle.load(url.join("assets", "tarif.db"));
    List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);
    return await openDatabase(path);

  }



  Future<List<malzeme>> malzemelereiGetir(int recipe_id) async {
    Database db = await instance.database;
    String sorgu = '''
    
    SELECT i.ingredient_name, ing.miktar
    FROM ingredients ing
    INNER JOIN ingredient i ON ing.ingredient_id = i.ingredient_id
    WHERE ing.recipe_id = ?
        ''';

    try {
      final List<Map<String, dynamic>> maps = await db.rawQuery(
          sorgu, [recipe_id]);
      print(maps);
      return List.generate(maps.length, (i) {
        return malzeme(

          ingredient_name: maps[i]['ingredient_name'],
          miktar: maps[i]['miktar'],
        );
      }
      );
    } catch (e) {
      print('hata buuuuu $e');
      return [];
    }
  }

  Future<List<recipe>> uygunTarifler(List<String> malzemeler) async {
    print('uygun tarifler çalıştı');
    Database db = await instance.database;
    String malzemeListesi = malzemeler.map((e) => "'$e'").join(',');
    print(malzemeListesi);
    String sorgu = '''
        SELECT recipe_id, recipe_name, recipe_steps,recipe_time
        FROM recipe
        WHERE recipe_id IN(
        SELECT recipe_id
        FROM ingredients ing
        INNER JOIN ingredient i ON ing.ingredient_id =i.ingredient_id
        WHERE i.ingredient_name IN ($malzemeListesi)
        GROUP BY recipe_id
        
        
        )
        ''';
    try {
      final List<Map<dynamic, dynamic>> maps = await db.rawQuery(sorgu);
      print(maps.toString());
      return List.generate(maps.length, (i) {
        return recipe(
            recipe_id: maps[i]['recipe_id'],
            recipe_name: maps[i]['recipe_name'],
            recipe_steps: maps[i]['recipe_steps'],
            recipe_time: maps[i]['recipe_time']);
      }
      );
    } catch (e) {
      print('***********************hata bu $e');
      return [];
    }
  }


// tüm tarifleri çekme
  Future<List<recipe>> getAllRecipes() async {
    Database db = await instance.database;
    String query = 'SELECT * FROM recipe';
    final List<Map<dynamic, dynamic>> maps = await db.rawQuery(query);
    try {
      return List.generate(maps.length, (i) {
        return recipe(
            recipe_id: maps[i]['recipe_id'],
            recipe_name: maps[i]['recipe_name'],
            recipe_steps: maps[i]['recipe_steps'],
            recipe_time: maps[i]['recipe_time']);
      }
      );
    } catch (e) {
      print('hata $e');
      return [];
    }
  }

//tarif detaylar
  Future<List<recipe>> getRecipeDetails(int recipe_id) async {
    final db = await database;
    String sorgu = 'SELECT recipe_id,recipe_name,recipe_steps,recipe_time FROM recipe WHERE recipe_id=?';

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        sorgu, [recipe_id]);
    print(maps.toString());
    try {
      return List.generate(maps.length, (i) {
        return recipe(
            recipe_id: maps[i]['recipe_id'],
            recipe_name: maps[i]['recipe_name'],
            recipe_steps: maps[i]['recipe_steps'],
            recipe_time: maps[i]['recipe_time']);
      }
      );
    } catch (e) {
      print('hata bu $e');
      return [];
    }
  }
}