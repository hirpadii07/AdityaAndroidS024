import 'package:floor/floor.dart';
import 'todo_item.dart';

@dao
abstract class ToDoDao {
  @Query('SELECT * FROM ToDoItem')
  Future<List<ToDoItem>> findAllToDoItems();

  @insert
  Future<void> insertToDoItem(ToDoItem todoItem);

  @delete
  Future<void> deleteToDoItem(ToDoItem todoItem);
}
