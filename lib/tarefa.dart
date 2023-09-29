import 'dart:convert';
import 'package:flutter/material.dart';
import 'adicionar_tarefa.dart';

class Tarefa {
  String titulo;
  String descricao;
  String dataVencimento;
  String prioridade;

  Tarefa({
    required this.titulo,
    required this.descricao,
    required this.dataVencimento,
    required this.prioridade,
  });

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'dataVencimento': dataVencimento,
      'prioridade': prioridade,
    };
  }

  factory Tarefa.fromJson(Map<String, dynamic> json) {
    return Tarefa(
      titulo: json['titulo'],
      descricao: json['descricao'],
      dataVencimento: json['dataVencimento'],
      prioridade: json['prioridade'],
    );
  }
}

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

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  List<Tarefa> tarefas = [];

  // Variável para controlar a ordem de classificação
  bool ordenarPorData = false;

  @override
  Widget build(BuildContext context) {
    // Ordena as tarefas com base na escolha atual (data ou prioridade)
    tarefas.sort((a, b) {
      if (ordenarPorData) {
        return a.dataVencimento.compareTo(b.dataVencimento);
      } else {
        return _compararPrioridades(a.prioridade, b.prioridade);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas App'),
        actions: [
          // Botão para ordenar por data
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              setState(() {
                ordenarPorData = true;
              });
            },
          ),
          // Botão para ordenar por prioridade
          IconButton(
            icon: Icon(Icons.priority_high),
            onPressed: () {
              setState(() {
                ordenarPorData = false;
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(tarefas[index].titulo),
              subtitle: Text(tarefas[index].descricao),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetalhesTarefa(tarefa: tarefas[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final tarefaJson = await Navigator.of(context).push<String>(
            MaterialPageRoute(
              builder: (context) => TarefasApp(),
            ),
          );

          if (tarefaJson != null) {
            Tarefa novaTarefa = Tarefa.fromJson(jsonDecode(tarefaJson));
            setState(() {
              tarefas.add(novaTarefa);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  int _compararPrioridades(String prioridadeA, String prioridadeB) {
    // Implemente a lógica para comparar as prioridades
    // Retorne um número negativo se A for menor que B, 0 se forem iguais e um número positivo se A for maior que B.
    if (prioridadeA == 'Alto') {
      return -1;
    } else if (prioridadeA == 'Médio') {
      if (prioridadeB == 'Alto') {
        return 1;
      } else {
        return -1;
      }
    } else {
      // Baixo
      if (prioridadeB == 'Alto' || prioridadeB == 'Médio') {
        return 1;
      } else {
        return 0;
      }
    }
  }
}

class DetalhesTarefa extends StatelessWidget {
  final Tarefa tarefa;

  DetalhesTarefa({required this.tarefa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Título: ${tarefa.titulo}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Descrição: ${tarefa.descricao}'),
            Text('Data de Vencimento: ${tarefa.dataVencimento}'),
            Text('Prioridade: ${tarefa.prioridade}'),
          ],
        ),
      ),
    );
  }
}
