import 'dart:convert';
import 'package:flutter/material.dart';
import 'tarefa.dart';

class EditarTarefa extends StatefulWidget {
  final Tarefa tarefa;

  EditarTarefa({required this.tarefa});

  @override
  _EditarTarefaState createState() => _EditarTarefaState();
}

class _EditarTarefaState extends State<EditarTarefa> {
  TextEditingController tituloController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController dataVencimentoController = TextEditingController();
  TextEditingController prioridadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tituloController.text = widget.tarefa.titulo;
    descricaoController.text = widget.tarefa.descricao;
    dataVencimentoController.text = widget.tarefa.dataVencimento;
    prioridadeController.text = widget.tarefa.prioridade;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: dataVencimentoController,
              decoration: InputDecoration(labelText: 'Data de Vencimento'),
            ),
            TextField(
              controller: prioridadeController,
              decoration: InputDecoration(labelText: 'Prioridade'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Atualizar os valores da tarefa com os dados inseridos
                widget.tarefa.titulo = tituloController.text;
                widget.tarefa.descricao = descricaoController.text;
                widget.tarefa.dataVencimento = dataVencimentoController.text;
                widget.tarefa.prioridade = prioridadeController.text;

                // Salvar as alterações
                _salvarAlteracoes(widget.tarefa);

                Navigator.of(context)
                    .pop(); // Voltar à tela de detalhes da tarefa
              },
              child: Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }

  void _salvarAlteracoes(Tarefa tarefa) {
    // Você pode implementar a lógica para salvar as alterações da tarefa aqui.
    // Por exemplo, você pode atualizar uma lista de tarefas no arquivo tarefa.dart
    // ou fazer outra operação de salvamento de acordo com sua necessidade.
  }
}
