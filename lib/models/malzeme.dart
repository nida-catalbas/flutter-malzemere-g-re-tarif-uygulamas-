import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';
import 'package:tarifuygulama/models/ingredient.dart';

class malzeme{

  final String ingredient_name;
  final String miktar;

  const malzeme({

    required this.ingredient_name,
    required this.miktar,
  });
  factory malzeme.fromJson(Map<dynamic,dynamic> json) => malzeme(

    ingredient_name: json['ingredient_name'],
    miktar: json['miktar']
  );

  Map<String,dynamic> toJson() {
    final map={

      'ingredient_name': ingredient_name,
      'miktar': miktar,
    };
    return map;
  }

}