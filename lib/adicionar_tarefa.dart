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
  final RegExp dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');

  if (!dateRegex.hasMatch(_dataVencimentoController.text)) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro de Data'),
          content: Text('A data de vencimento deve estar no formato DD/MM/AAAA.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    return;
  }

  final List<String> dataVencimentoParts = _dataVencimentoController.text.split('/');
  final int dia = int.parse(dataVencimentoParts[0]);
  final int mes = int.parse(dataVencimentoParts[1]);
  final int ano = int.parse(dataVencimentoParts[2]);
  
  final DateTime dataAtual = DateTime.now();
  
  if (mes < 1 || mes > 12) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro de Data'),
          content: Text('O mês deve estar entre 1 e 12.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    return;
  }
  
  if (dia < 1 || dia > 31) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro de Data'),
          content: Text('O dia deve estar entre 1 e 31.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    return;
  }
  
  if ((mes == 4 || mes == 6 || mes == 9 || mes == 11) && dia > 30) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro de Data'),
          content: Text('O mês $mes não tem $dia dias.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    return;
  }
  
  if (mes == 2) {
    if ((ano % 4 == 0 && ano % 100 != 0) || (ano % 400 == 0)) {
      if (dia > 29) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erro de Data'),
              content: Text('Fevereiro de $ano tem no máximo 29 dias.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }
    } else {
      if (dia > 28) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erro de Data'),
              content: Text('Fevereiro de $ano tem no máximo 28 dias.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }
    }
  }
  
  if (ano < dataAtual.year) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro de Data'),
          content: Text('O ano não pode ser anterior ao ano atual.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    return;
  }

  final DateTime dataVencimento = DateTime(ano, mes, dia);

  if (dataVencimento.isBefore(dataAtual)) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro de Data'),
          content: Text('A data de vencimento não pode ser anterior à data atual.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    return;
  }

  Tarefa novaTarefa = Tarefa(
    titulo: _tituloController.text,
    descricao: _descricaoController.text,
    dataVencimento: _dataVencimentoController.text,
    prioridade: _prioridadeSelecionada,
  );

  String tarefaJson = jsonEncode(novaTarefa);

  Navigator.of(context).pop(tarefaJson);
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
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  DataInputFormatter(),
                ],
                keyboardType: TextInputType.number,
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
