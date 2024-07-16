import 'package:floor/floor.dart';

@entity
class ToDoItem {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;

  ToDoItem(this.id, this.name);
}
