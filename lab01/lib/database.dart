import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'todo_dao.dart';
import 'todo_item.dart';

part 'database.g.dart';

@Database(version: 1, entities: [ToDoItem])
abstract class AppDatabase extends FloorDatabase {
  ToDoDao get todoDao;
}
