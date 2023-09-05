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
  String emojiDescription = ''; // Variável para armazenar a descrição do emoji selecionado

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
      } else {
        final uncompletedTask = tasks.removeAt(index);
        int insertIndex = tasks.indexWhere((task) => !task['completed']);
        if (insertIndex == -1) {
          tasks.add(uncompletedTask);
        } else {
          tasks.insert(insertIndex, uncompletedTask);
        }
      }
    });
    _saveTasks(); // Save tasks after toggling
  }

  void _addTask(String taskTitle) {
    if (taskTitle.isNotEmpty) {
      setState(() {
        tasks.insert(0, {'task': taskTitle, 'completed': false});
      });
      _saveTasks(); // Save tasks after adding
    }
  }

  void _showEmojiDescription(String emoji) {
    setState(() {
      switch (emoji) {
        case '😃':
          emojiDescription = 'Aproveite cada momento de alegria, pois são esses momentos que fazem a vida valer a pena';
          break;
        case '😢':
          emojiDescription = 'Lembre-se de que a tristeza é apenas uma nuvem passageira no céu da sua vida. O sol sempre volta a brilhar';
          break;
        case '😐':
          emojiDescription = 'É completamente normal ter altos e baixos na vida. A jornada é feita de todos esses momentos, e todos eles têm seu valor';
          break;
        default:
          emojiDescription = '';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Theme.of(context).primaryColor, // Define a mesma cor da AppBar
            child: Column(
              children: [
                Text(
                  'Como você está se sentindo?',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.black, // Define a cor do texto para branco
                  ),
                  textAlign: TextAlign.center, // Centraliza o texto
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showEmojiDescription('😃'); // Mostrar descrição feliz
                      },
                      child: Text(
                        '😃',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showEmojiDescription('😢'); // Mostrar descrição triste
                      },
                      child: Text(
                        '😢',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showEmojiDescription('😐'); // Mostrar descrição normal
                      },
                      child: Text(
                        '😐',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            emojiDescription,
            style: TextStyle(fontSize: 15.0),
            textAlign: TextAlign.center, // Centraliza o texto
          ),
          Expanded(
            child: ListView.builder(
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
                      _saveTasks(); // Salvar as tarefas após remover
                    });
                  },
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
                      trailing: isCompleted
                          ? Icon(Icons.check, color: Colors.green)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
                      _addTask(_newTaskController.text);
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
