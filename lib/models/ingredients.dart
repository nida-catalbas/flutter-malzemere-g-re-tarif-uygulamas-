import 'package:sqflite/sqflite.dart';
import 'package:tarifuygulama/models/ingredient.dart';
import 'dart:typed_data';

import 'package:tarifuygulama/models/ingredients.dart';
import 'package:tarifuygulama/models/recipe.dart';



class ingredients{
  final int ingredients_id;
  final int recipe_id;
  final int ingredient_id;
  final String miktar;

  const ingredients({
    required this.ingredients_id,
    required this.ingredient_id,
    required this.recipe_id,
    required this.miktar,
});

  factory ingredients.fromJson(Map<dynamic,dynamic> json) => ingredients(
    ingredients_id: json['ingredients_id'],
    ingredient_id: json['ingredient_id'],
    recipe_id: json['recipe_id'],
    miktar: json['miktar']
  );
  Map<String,dynamic> toJson(){
    final map={
      'ingredients_id':ingredient_id,
      'ingredient_id':ingredient_id,
      'recipe_id':recipe_id,
      'miktar':miktar,
    };
    return map;
  }

}