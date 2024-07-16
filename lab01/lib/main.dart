import 'package:flutter/material.dart';
import 'database.dart';
import 'todo_item.dart';
import 'todo_dao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final todoDao = database.todoDao;

  runApp(MyApp(todoDao));
}

class MyApp extends StatelessWidget {
  final ToDoDao todoDao;

  MyApp(this.todoDao);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      home: ToDoListPage(todoDao),
    );
  }
}

class ToDoListPage extends StatefulWidget {
  final ToDoDao todoDao;

  ToDoListPage(this.todoDao);

  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List<ToDoItem> todoItems = [];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadToDoItems();
  }

  Future<void> _loadToDoItems() async {
    try {
      final items = await widget.todoDao.findAllToDoItems();
      setState(() {
        todoItems = items;
      });
      print('Loaded items: ${items.length}');
    } catch (e) {
      print('Error loading items: $e');
    }
  }

  Future<void> _addToDoItem(String name) async {
    if (name.isEmpty) return;
    final newItem = ToDoItem(null, name);
    try {
      await widget.todoDao.insertToDoItem(newItem);
      print('Added item: $name');
      _loadToDoItems();
      _controller.clear();
    } catch (e) {
      print('Error adding item: $e');
    }
  }

  Future<void> _deleteToDoItem(ToDoItem item) async {
    try {
      await widget.todoDao.deleteToDoItem(item);
      print('Deleted item: ${item.name}');
      _loadToDoItems();
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter a to-do item',
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Text("Add"),
                  onPressed: () => _addToDoItem(_controller.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: todoItems.isEmpty
                ? Center(
              child: Text("There are no items in the list"),
            )
                : ListView.builder(
              itemCount: todoItems.length,
              itemBuilder: (context, index) {
                final item = todoItems[index];
                return GestureDetector(
                  onLongPress: () {
                    _showDeleteDialog(item);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Row number: ${index + 0}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item.name),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(ToDoItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Item"),
          content: Text("Do you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () {
                _deleteToDoItem(item);
                Navigator.of(context).pop();
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }
}

