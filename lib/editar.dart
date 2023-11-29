import 'package:flutter/material.dart';
import 'tarefa.dart';

class EditarTarefa extends StatefulWidget {
  final Tarefa tarefa;
  final Function(Tarefa) atualizarTarefa; // Adicionado novo parâmetro

  const EditarTarefa({super.key, required this.tarefa, required this.atualizarTarefa});

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
        title: const Text('Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: dataVencimentoController,
              decoration: const InputDecoration(labelText: 'Data de Vencimento'),
            ),
            TextField(
              controller: prioridadeController,
              decoration: const InputDecoration(labelText: 'Prioridade'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Atualizar os valores da tarefa com os dados inseridos
                widget.tarefa.titulo = tituloController.text;
                widget.tarefa.descricao = descricaoController.text;
                widget.tarefa.dataVencimento = dataVencimentoController.text;
                widget.tarefa.prioridade = prioridadeController.text;

                // Chame a função para atualizar a tarefa no arquivo principal
                widget.atualizarTarefa(widget.tarefa);

                Navigator.of(context)
                    .pop(); // Voltar à tela de detalhes da tarefa
              },
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
