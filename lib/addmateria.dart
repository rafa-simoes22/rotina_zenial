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
  final TextEditingController _pontosNecessariosController = TextEditingController();
  String _nivelDificuldade = 'Baixo';

  @override
  void initState() {
    super.initState();
    _dataLimiteController.addListener(_formatDate);
  }

  @override
  void dispose() {
    _dataLimiteController.removeListener(_formatDate);
    super.dispose();
  }

  void _formatDate() {
    final text = _dataLimiteController.text;
    if (text.length == 2 || text.length == 5) {
      _dataLimiteController.text = '$text/';
      _dataLimiteController.selection = TextSelection.fromPosition(
          TextPosition(offset: _dataLimiteController.text.length));
    }
  }

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
              controller: _pontosNecessariosController,
              decoration: InputDecoration(labelText: 'Pontos Necessários'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira os pontos necessários.';
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
              decoration: InputDecoration(labelText: 'Prazo Estipulado (DD/MM/YY)'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o prazo estipulado.';
                }
                if (!isDateValid(value)) {
                  return 'Formato de data inválido. Use o formato DD/MM/YY.';
                }
                return null;
              },
            ),
            Row(
              children: [
                Text('Nível de Dificuldade: '),
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
                          child: Text(value),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final String nome = _nomeController.text;
                  final String pontosNecessarios = _pontosNecessariosController.text;
                  final String pontosAdquiridos = _pontosAdquiridosController.text;
                  final String dataLimite = _dataLimiteController.text;

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
    );
  }

  bool isDateValid(String date) {
    if (date.length != 8) return false;
    final day = int.tryParse(date.substring(0, 2));
    final month = int.tryParse(date.substring(2, 4));
    final year = int.tryParse(date.substring(4, 6));

    if (day == null || month == null || year == null) return false;
    if (day < 1 || day > 31 || month < 1 || month > 12 || year < 0 || year > 50) return false;

    return true;
  }
}

class Materia {
  final String nome;
  final String pontosAdquiridos;
  final String dataLimite;
  final String nivelDificuldade;
  final String pontosNecessarios;

  Materia(this.nome, this.pontosAdquiridos, this.dataLimite, this.nivelDificuldade, this.pontosNecessarios);
}
