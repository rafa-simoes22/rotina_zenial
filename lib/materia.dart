import 'package:flutter/material.dart';
import 'addmateria.dart';

class MateriaPage extends StatefulWidget {
  final List<Materia> materias;

  MateriaPage({required this.materias});

  @override
  _MateriaPageState createState() => _MateriaPageState();
}

class _MateriaPageState extends State<MateriaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matérias'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MaterialList(materias: widget.materias),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final novaMateria = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AdicionarMateriaPage(onMateriaAdicionada: (Materia novaMateria) {
                    // Exibir os detalhes da matéria aqui
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Detalhes da Matéria'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nome da Matéria: ${novaMateria.nome}'),
                              Text('Pontos Necessários: ${novaMateria.pontosNecessarios}'),
                              Text('Prazo Estipulado: ${novaMateria.dataLimite}'),
                              Text('Nível de Dificuldade: ${novaMateria.nivelDificuldade}'),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(novaMateria);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }),
                ),
              );

              if (novaMateria != null) {
                setState(() {
                  widget.materias.add(novaMateria);
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
