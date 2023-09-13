import 'package:flutter/material.dart';
import 'adicionar_tarefa.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navegar para a tela de adicionar tarefa quando o botão for pressionado
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TarefasApp(), // Usando TarefasApp para a tela de adicionar tarefa
            ));
          },
          child: Text('Adicionar Tarefa'),
        ),
      ),
    );
  }
}
