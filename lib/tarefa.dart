import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'adicionar_tarefa.dart';
import 'editar.dart';
import 'materia.dart';

class Tarefa {
  String titulo;
  String descricao;
  String dataVencimento;
  String prioridade;
  bool concluida;

  Tarefa({
    required this.titulo,
    required this.descricao,
    required this.dataVencimento,
    required this.prioridade,
    this.concluida = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'dataVencimento': dataVencimento,
      'prioridade': prioridade,
      'concluida': concluida,
    };
  }

  factory Tarefa.fromJson(Map<String, dynamic> json) {
    return Tarefa(
      titulo: json['titulo'],
      descricao: json['descricao'],
      dataVencimento: json['dataVencimento'],
      prioridade: json['prioridade'],
      concluida: json['concluida'] ?? false,
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
      home: TelaPrincipal(username: ""), // Inicializa com nome de usuário vazio
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  final String username; // Adiciona um parâmetro para o nome de usuário

  TelaPrincipal({required this.username}); // Construtor

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  List<Tarefa> tarefas = [];

  bool ordenarPorData = false;
  bool ordenarPorPrioridade = false;

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _carregarTarefasSalvas();
  }

  Future<void> _carregarTarefasSalvas() async {
    _prefs = await SharedPreferences.getInstance();
    final tarefasJson = _prefs.getStringList('tarefas') ?? [];
    setState(() {
      tarefas = tarefasJson.map((json) => Tarefa.fromJson(jsonDecode(json))).toList();
    });
  }

  Future<void> _salvarTarefas() async {
    final tarefasJson = tarefas.map((tarefa) => jsonEncode(tarefa.toJson())).toList();
    await _prefs.setStringList('tarefas', tarefasJson);
  }

  void _ordernarTarefasPorData() {
    setState(() {
      ordenarPorData = true;
      ordenarPorPrioridade = false;
      tarefas.sort((a, b) {
        if (a.concluida && !b.concluida) {
          return 1;
        } else if (!a.concluida && b.concluida) {
          return -1;
        } else {
          return a.dataVencimento.compareTo(b.dataVencimento);
        }
      });
    });
  }

  void _ordernarTarefasPorPrioridade() {
    setState(() {
      ordenarPorData = false;
      ordenarPorPrioridade = true;
      tarefas.sort((a, b) {
        if (a.concluida && !b.concluida) {
          return 1;
        } else if (!a.concluida && b.concluida) {
          return -1;
        } else {
          return _compararPrioridades(a.prioridade, b.prioridade);
        }
      });
    });
  }

  void _mostrarTelaEditar(BuildContext context, Tarefa tarefa) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditarTarefa(
          tarefa: tarefa,
          atualizarTarefa: (tarefaAtualizada) {
            // Atualize a tarefa na lista
            final index = tarefas.indexOf(tarefa);
            if (index != -1) {
              setState(() {
                tarefas[index] = tarefaAtualizada;
                _salvarTarefas();
              });
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rotina Zenial'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _ordernarTarefasPorData,
          ),
          IconButton(
            icon: Icon(Icons.priority_high),
            onPressed: _ordernarTarefasPorPrioridade,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Olá, ${widget.username}! Aqui estão suas tarefas:'),
          ),
          Expanded(
            child: ReorderableListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = tarefas[index];
                return Card(
                  key: Key(tarefa.titulo),
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(tarefa.titulo),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tarefa.prioridade),
                        Text(tarefa.dataVencimento),
                      ],
                    ),
                    trailing: Checkbox(
                      value: tarefa.concluida,
                      onChanged: (value) {
                        setState(() {
                          tarefa.concluida = value ?? false;
                          _salvarTarefas();
                        });
                      },
                    ),
                    onTap: () {
                      _mostrarOpcoes(context, tarefa);
                    },
                  ),
                );
              },
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final Tarefa tarefa = tarefas.removeAt(oldIndex);
                  tarefas.insert(newIndex, tarefa);
                  _salvarTarefas();
                });
              },
            ),
          ),
          ElevatedButton( // Botão para ver as Matérias
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MateriaPage(materias: [],),
                ),
              );
            },
            child: Text('Ver Matérias'),
          ),
        ],
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
            await _salvarTarefas();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  int _compararPrioridades(String prioridadeA, String prioridadeB) {
    if (prioridadeA == 'Alto') {
      return -1;
    } else if (prioridadeA == 'Médio') {
      if (prioridadeB == 'Alto') {
        return 1;
      } else {
        return -1;
      }
    } else {
      if (prioridadeB == 'Alto' || prioridadeB == 'Médio') {
        return 1;
      } else {
        return 0;
      }
    }
  }

  void _mostrarOpcoes(BuildContext context, Tarefa tarefa) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.description),
                title: Text('Detalhes da Tarefa'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetalhesTarefa(tarefa: tarefa),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.edit), // Adicione um ícone de edição
                title: Text('Editar Tarefa'), // Altere o texto do botão
                onTap: () {
                  Navigator.of(context).pop();
                  _mostrarTelaEditar(context, tarefa); // Chama a tela de edição
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Excluir Tarefa'),
                onTap: () {
                  setState(() {
                    tarefas.remove(tarefa);
                    _salvarTarefas();
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
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
            Text('Concluída: ${tarefa.concluida ? 'Sim' : 'Não'}'),
          ],
        ),
      ),
    );
  }
}
