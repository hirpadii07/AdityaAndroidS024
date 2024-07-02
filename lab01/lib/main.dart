import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      home: ToDoListPage(),
    );
  }
}

class ToDoListPage extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List<String> todoItems = [];
  TextEditingController _controller = TextEditingController();

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: Text("Add"),
                  onPressed: () {
                    setState(() {
                      todoItems.add(_controller.value.text);
                      _controller.clear();
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter a to-do item',
                    ),
                  ),
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
                return GestureDetector(
                  onLongPress: () {
                    _showDeleteDialog(index);
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
                        child: Text(todoItems[index]),
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

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Item"),
          content: Text("Do you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  todoItems.removeAt(index);
                });
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
