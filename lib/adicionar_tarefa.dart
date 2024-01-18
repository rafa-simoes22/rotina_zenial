import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  runApp(MaterialApp(
    home: TarefasApp(),
  ));
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
    // código do método _adicionarTarefa aqui
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Adicionar Tarefa:'),
          
        ),
        body: Container(
          color: Color.fromARGB(255, 213, 248, 148), // Cor de fundo
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      DataInputFormatter(),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Data de Vencimento (DD/MM/AAAA)',
                    ),
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
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF568200), // Cor de fundo do botão
                    ),
                    child: Text(
                      'Adicionar Tarefa',
                      style: TextStyle(
                        color: Colors.white, // Cor do texto do botão
                        fontFamily: 'ArimaMadurai', // Fonte do texto do botão
 fontWeight: FontWeight.bold, // Deixa o texto mais grosso
    
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DataInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final StringBuffer newText = StringBuffer();
    final String trimmedValue = newValue.text.replaceAll("/", "");

    if (trimmedValue.length >= 2) {
      newText.write(trimmedValue.substring(0, 2) + '/');
      if (trimmedValue.length >= 4) {
        newText.write(trimmedValue.substring(2, 4) + '/');
        if (trimmedValue.length >= 8) {
          newText.write(trimmedValue.substring(4, 8));
        } else {
          newText.write(trimmedValue.substring(4));
        }
      } else {
        newText.write(trimmedValue.substring(2));
      }
    } else {
      newText.write(trimmedValue);
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
