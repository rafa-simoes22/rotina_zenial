import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(TaskListApp());

class TaskListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
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

  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index]['completed'] = !tasks[index]['completed'];
    });
    _saveTasks(); // Save tasks after toggling
  }

  void addNewTask(String newTask) {
    setState(() {
      tasks.add({'task': newTask, 'completed': false});
    });
    _saveTasks(); // Save tasks after adding
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          String task = tasks[index]['task'];
          bool isCompleted = tasks[index]['completed'];

          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              setState(() {
                tasks.removeAt(index);
              });
              _saveTasks(); // Save tasks after removing
            },
            child: ListTile(
              title: Text(
                task,
                style: TextStyle(
                  color: isCompleted ? Colors.green : Colors.teal,
                  decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              leading: Checkbox(
                value: isCompleted,
                onChanged: (value) {
                  toggleTaskCompletion(index);
                },
              ),
              trailing: isCompleted ? Icon(Icons.check, color: Colors.green) : null,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Adicionar Tarefa'),
                content: TextField(
                  controller: _newTaskController,
                  decoration: InputDecoration(labelText: 'Digite a nova tarefa'),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      addNewTask(_newTaskController.text);
                      _newTaskController.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text('Adicionar'),
                  ),
                ],
              );
            },
          );
        },
        label: Text('Adicionar Tarefa'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
