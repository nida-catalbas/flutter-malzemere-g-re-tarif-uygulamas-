import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';
import 'package:tarifuygulama/models/ingredient.dart';

class ingredient{
  final int ingredient_id;
  final String ingredient_name;

  const ingredient({
    required this.ingredient_id,
    required this.ingredient_name,
});
  factory ingredient.fromJson(Map<dynamic,dynamic> json) => ingredient(
    ingredient_id: json['ingredient_id'],
    ingredient_name: json['ingredient_name'],
  );

  Map<String,dynamic> toJson() {
    final map={
      'ingredient_id': ingredient_id,
      'ingredient_name': ingredient_name
    };
    return map;
  }

}