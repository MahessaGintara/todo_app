import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String note;

  @HiveField(2)
  String category;

  @HiveField(3)
  bool isComplete;

  Todo(this.title, this.note, this.category, this.isComplete);
}

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late List colors;

  String toString() => name;
}
