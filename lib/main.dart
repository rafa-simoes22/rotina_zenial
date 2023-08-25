import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Map<String, dynamic>> tasks = [];

  TextEditingController _newTaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    try {
      final file = File(await _getFilePath());
      final contents = await file.readAsString();
      setState(() {
        tasks = (json.decode(contents) as List<dynamic>).cast<Map<String, dynamic>>();
      });
    } catch (e) {
      // Error reading file, handle as needed
    }
  }

  Future<void> _saveTasks() async {
    final file = File(await _getFilePath());
    final encodedTasks = json.encode(tasks);
    await file.writeAsString(encodedTasks);
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/tasks.json';
  }

  void _toggleTask(int index) {
    setState(() {
      tasks[index]['completed'] = !tasks[index]['completed'];

      if (tasks[index]['completed']) {
        final completedTask = tasks.removeAt(index);
        tasks.add(completedTask);
      }
    });
    _saveTasks(); // Save tasks after toggling
  }

  void _addTask(String taskTitle) {
    if (taskTitle.isNotEmpty) {
      setState(() {
        tasks.add({'task': taskTitle, 'completed': false});
      });
      _saveTasks(); // Save tasks after adding
    }
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    _saveTasks(); // Save tasks after deleting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                String task = tasks[index]['task'];
                bool isCompleted = tasks[index]['completed'];

                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (_) => _deleteTask(index),
                  child: GestureDetector(
                    onTap: () => _toggleTask(index),
                    child: ListTile(
                      title: Text(
                        task,
                        style: TextStyle(
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newTaskController,
                    decoration: InputDecoration(
                      hintText: 'Adicionar tarefa...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _addTask(_newTaskController.text);
                    _newTaskController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
