import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'materia.dart';

class AdicionarMateriaPage extends StatefulWidget {
  final List<Materia> materias;
  final Function(Materia) adicionarMateria;

  AdicionarMateriaPage({
    required this.materias,
    required this.adicionarMateria,
  });

  @override
  _AdicionarMateriaPageState createState() => _AdicionarMateriaPageState();
}

class _AdicionarMateriaPageState extends State<AdicionarMateriaPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _pontosAdquiridosController = TextEditingController();
  TextEditingController _dataLimiteController = TextEditingController();
  String _nivelDificuldadeSelecionado = 'Fácil';
  TextEditingController _pontosNecessariosController = TextEditingController();

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
        title: Text('Adicionar Matéria'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome da Matéria'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da matéria.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _pontosAdquiridosController,
                decoration: InputDecoration(labelText: 'Pontos Adquiridos'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _dataLimiteController,
                decoration: InputDecoration(labelText: 'Data Limite (DD/MM/AAAA)'),
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
                decoration: InputDecoration(labelText: 'Nível de Dificuldade'),
              ),
              TextFormField(
                controller: _pontosNecessariosController,
                decoration: InputDecoration(labelText: 'Pontos Necessários'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _adicionarMateria,
                child: Text('Adicionar Matéria'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
