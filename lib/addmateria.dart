import 'package:flutter/material.dart';
import 'materia.dart';

class AdicionarMateriaPage extends StatefulWidget {
  final List<Materia> materias;
  final Function(Materia) adicionarMateria;

  const AdicionarMateriaPage({super.key, 
    required this.materias,
    required this.adicionarMateria,
  });

  @override
  _AdicionarMateriaPageState createState() => _AdicionarMateriaPageState();
}

class _AdicionarMateriaPageState extends State<AdicionarMateriaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _pontosAdquiridosController = TextEditingController();
  final TextEditingController _dataLimiteController = TextEditingController();
  String _nivelDificuldadeSelecionado = 'Fácil';
  final TextEditingController _pontosNecessariosController = TextEditingController();

  void _adicionarMateria() {
    if (_formKey.currentState!.validate()) {
      Materia novaMateria = Materia(
        nome: _nomeController.text,
        pontosAdquiridos: _pontosAdquiridosController.text,
        dataLimite: _dataLimiteController.text,
        nivelDificuldade: _nivelDificuldadeSelecionado,
        pontosNecessarios: _pontosNecessariosController.text,
      );

      setState(() {
        widget.materias.add(novaMateria);
        widget.adicionarMateria(novaMateria);
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Matéria'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome da Matéria'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da matéria.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _pontosAdquiridosController,
                decoration: const InputDecoration(labelText: 'Pontos Adquiridos'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _dataLimiteController,
                decoration: const InputDecoration(labelText: 'Data Limite (DD/MM/AAAA)'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  // Adicione validação de data aqui
                  return null; // Retorne uma mensagem de erro se a data for inválida
                },
              ),
              DropdownButtonFormField<String>(
                value: _nivelDificuldadeSelecionado,
                onChanged: (String? newValue) {
                  setState(() {
                    _nivelDificuldadeSelecionado = newValue!;
                  });
                },
                items: <String>['Fácil', 'Médio', 'Difícil']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                decoration: const InputDecoration(labelText: 'Nível de Dificuldade'),
              ),
              TextFormField(
                controller: _pontosNecessariosController,
                decoration: const InputDecoration(labelText: 'Pontos Necessários'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _adicionarMateria,
                child: const Text('Adicionar Matéria'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
