//todo_repository.dart: An intermediary class to interact with the database.

//todo_model.dart: Define the Todo model class to represent our Todo items.
import 'package:sqliteproj/database/db_helper.dart';
import 'package:sqliteproj/model/todo_model.dart';

class TodoRepository {
  final dbHelper = DBHelper.dbHero;
  Future<int> insert(Todo todo) async {
    return await dbHelper.insertDb(todo.toMap());
  }

  Future<List<Todo>> getAllTodos() async {
    final List<Map<String, dynamic>> maps = await dbHelper.readDb();
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
      );
    });
  }

  Future<int> update(Todo todo) async {
    return await dbHelper.updateDb(todo.toMap());
  }

  Future<int> delete(int id) async {
    return await dbHelper.deleteDb(id);
  }
}
