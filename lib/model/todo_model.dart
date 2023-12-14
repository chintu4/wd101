import "package:flutter/material.dart";

//todo_model.dart: Define the Todo model class to represent our Todo items.
class Todo {
  int? id;
  String name;
  String description;

  Todo({
    this.id,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
