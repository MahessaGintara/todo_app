import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/adapters/todo.dart';

class Boxes {
  static Box<Todo> getTodos() => Hive.box<Todo>('todos');
  static Box<Category> getCategory() => Hive.box<Category>('categories');
}
