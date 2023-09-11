import 'package:flutter/material.dart';

void main() {
  runApp(TarefasApp());
}

class TarefasApp extends StatefulWidget {
  @override
  _TarefasAppState createState() => _TarefasAppState();
}

class _TarefasAppState extends State<TarefasApp> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _dataVencimentoController = TextEditingController();
  String _prioridadeSelecionada = 'Alto';

  void _adicionarTarefa() {
    // Aqui você pode lidar com a lógica para adicionar tarefas
    // Os valores estão disponíveis nos controladores (_tituloController, _descricaoController, etc.)
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tarefas App'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
              TextFormField(
                controller: _dataVencimentoController,
                decoration: InputDecoration(labelText: 'Data de Vencimento (DD/MM/AAAA)'),
              ),
              DropdownButtonFormField<String>(
                value: _prioridadeSelecionada,
                onChanged: (String? newValue) {
                  setState(() {
                    _prioridadeSelecionada = newValue!;
                  });
                },
                items: <String>['Alto', 'Médio', 'Baixo']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                decoration: InputDecoration(labelText: 'Prioridade'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _adicionarTarefa,
                child: Text('Adicionar Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
