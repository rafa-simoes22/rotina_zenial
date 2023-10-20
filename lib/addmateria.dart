import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String _prazoEstipulado = 'Dias';
  String _nivelDificuldade = 'Baixo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Matéria'),
      ),
      body: Form(
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
              controller: _dataLimiteController,
              decoration: InputDecoration(labelText: 'Prazo Estipulado (Data)'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o prazo estipulado.';
                }
                return null;
              },
            ),
            DropdownButton<String>(
              value: _prazoEstipulado,
              onChanged: (String? newValue) {
                setState(() {
                  _prazoEstipulado = newValue!;
                });
              },
              items: <String>['Dias', 'Semanas', 'Meses']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
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

                  final novaMateria =
                      Materia(nome, pontosAdquiridos, dataLimite, _prazoEstipulado, _nivelDificuldade);
                  widget.onMateriaAdicionada(novaMateria);
                  Navigator.pop(context, novaMateria);
                }
              },
              child: Text('Adicionar Matéria'),
            ),
          ],
        ),
      ),
    );
  }
}

class Materia {
  final String nome;
  final String pontosAdquiridos;
  final String dataLimite;
  final String prazoEstipulado;
  final String nivelDificuldade;

  Materia(this.nome, this.pontosAdquiridos, this.dataLimite, this.prazoEstipulado, this.nivelDificuldade);
}
