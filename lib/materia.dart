import 'package:flutter/material.dart';
import 'addmateria.dart';

class MateriaPage extends StatefulWidget {
  @override
  _MateriaPageState createState() => _MateriaPageState();
}

class _MateriaPageState extends State<MateriaPage> {
  List<Materia> materias = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matérias'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MaterialList(materias: materias),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final novaMateria = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AdicionarMateriaPage(onMateriaAdicionada: (Materia ) {  },),
                ),
              );

              if (novaMateria != null) {
                setState(() {
                  materias.add(novaMateria);
                });
              }
            },
            child: Text('Adicionar Matéria'),
          ),
        ],
      ),
    );
  }
}

class MaterialList extends StatelessWidget {
  final List<Materia> materias;

  MaterialList({required this.materias});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: materias.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(materias[index].nome),
            subtitle: Text(materias[index].pontosAdquiridos),
            trailing: Text(materias[index].dataLimite),
          ),
        );
      },
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


