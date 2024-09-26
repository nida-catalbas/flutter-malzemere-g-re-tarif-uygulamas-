import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';

class recipe{
  final int recipe_id;
  final String recipe_name;
  final String recipe_steps;
  final int recipe_time;

  const recipe({
    required this.recipe_id,
    required this.recipe_name,
    required this.recipe_steps,
    required this.recipe_time,
});
factory recipe.fromJson(Map<dynamic, dynamic> json) => recipe(
    recipe_id: json['recipe_id'],
    recipe_name: json['recipe_name'],
    recipe_steps: json['recipe_steps'],
    recipe_time: json['recipe_time']
);
  Map<String,dynamic> toJson(){
    final map={
      'recipe_id':recipe_id,
      'recipe_name':recipe_name,
      'recipe_steps':recipe_steps,
      'recipe_time':recipe_time
    };
    return map;
  }
  }
