import 'package:flutter/material.dart';

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
  List<String> tasks = [
    '1 - Estudar matemática',
    '2 - Estudar bioquímica',
    '3 - Estudar literatura',
    '4 - Fazer simulado de física',
    '5 - Ver vídeo aula de história',
    '6 - Ler A República de Platão',
  ];

  List<bool> taskCompleted = List.generate(6, (index) => false);

  TextEditingController _newTaskController = TextEditingController();

  void toggleTaskCompletion(int index) {
    setState(() {
      taskCompleted[index] = !taskCompleted[index];
    });
  }

  void addNewTask(String newTask) {
    setState(() {
      tasks.add(newTask);
      taskCompleted.add(false);
    });
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
          String task = tasks[index];
          bool isCompleted = taskCompleted[index];

          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              setState(() {
                tasks.removeAt(index);
                taskCompleted.removeAt(index);
              });
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
