import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AdicionarMateriaPage extends StatefulWidget {
  final Function(Materia) onMateriaAdicionada;

  AdicionarMateriaPage({required this.onMateriaAdicionada});

  @override
  _AdicionarMateriaPageState createState() => _AdicionarMateriaPageState();
}

class _AdicionarMateriaPageState extends State<AdicionarMateriaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _pontosAdquiridosController = TextEditingController();
  final TextEditingController _dataLimiteController = TextEditingController();
  final TextEditingController _pontosNecessariosController = TextEditingController();
  String _nivelDificuldade = 'Baixo';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Matéria'),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                decoration: InputDecoration(labelText: 'Pontos já adquiridos'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira os pontos adquiridos.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _pontosNecessariosController,
                decoration: InputDecoration(labelText: 'Pontos Necessários'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira os pontos necessários.';
                  }
                  return null;
                },
              ),
              InkWell(
                onTap: () {
                  _showDatePicker(context);
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: _dataLimiteController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: 'Prazo Estipulado (DD/MM/AAAA)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a data limite.';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              DropdownButton<String>(
                value: _nivelDificuldade,
                onChanged: (String? newValue) {
                  setState(() {
                    _nivelDificuldade = newValue!;
                  });
                },
                items: <String>['Baixo', 'Médio', 'Alto']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text('Nível de dificuldade: $value'),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final String nome = _nomeController.text;
                    final String pontosAdquiridos = _pontosAdquiridosController.text;
                    final String dataLimite = _dataLimiteController.text;
                    final String pontosNecessarios = _pontosNecessariosController.text;

                    final novaMateria = Materia(
                      nome,
                      pontosAdquiridos,
                      dataLimite,
                      _nivelDificuldade,
                      pontosNecessarios,
                    );
                    widget.onMateriaAdicionada(novaMateria);
                    Navigator.pop(context, novaMateria);
                  }
                },
                child: Text('Adicionar Matéria'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(Duration(days: 365 * 50)), // Limite de 50 anos
      onConfirm: (date) {
        String formattedDate = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString()}";
        _dataLimiteController.text = formattedDate;
      },
    );
  }
}

class Materia {
  final String nome;
  final String pontosAdquiridos;
  final String dataLimite;
  final String nivelDificuldade;
  final String pontosNecessarios;

  Materia(
    this.nome,
    this.pontosAdquiridos,
    this.dataLimite,
    this.nivelDificuldade,
    this.pontosNecessarios,
  );
}
