import 'package:flutter/material.dart';

class Materia {
  String nome;
  String pontosAdquiridos;
  String dataLimite;
  String nivelDificuldade;
  String pontosNecessarios;

  Materia({
    required this.nome,
    required this.pontosAdquiridos,
    required this.dataLimite,
    required this.nivelDificuldade,
    required this.pontosNecessarios,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'pontosAdquiridos': pontosAdquiridos,
      'dataLimite': dataLimite,
      'nivelDificuldade': nivelDificuldade,
      'pontosNecessarios': pontosNecessarios,
    };
  }

  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(
      nome: json['nome'],
      pontosAdquiridos: json['pontosAdquiridos'],
      dataLimite: json['dataLimite'],
      nivelDificuldade: json['nivelDificuldade'],
      pontosNecessarios: json['pontosNecessarios'],
    );
  }
}

class MateriaPage extends StatelessWidget {
  final List<Materia> materias;

  MateriaPage({required this.materias});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matérias'),
      ),
      body: ListView.builder(
        itemCount: materias.length,
        itemBuilder: (context, index) {
          final materia = materias[index];
          return ListTile(
            title: Text(materia.nome),
            subtitle: Text('Pontos Adquiridos: ${materia.pontosAdquiridos}'),
          );
        },
      ));
    }
  }

