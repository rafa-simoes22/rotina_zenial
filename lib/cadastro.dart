import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'login.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    final String username = nameController.text;
    final String password = passwordController.text;

    final database = await openDatabase(
      join(await getDatabasesPath(), 'user_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, password TEXT)',
        );
      },
      version: 1,
    );

    final List<Map<String, dynamic>> existingUsers = await database.query(
      'users',
      where: 'name = ?',
      whereArgs: [username],
    );

    if (existingUsers.isEmpty) {
      await database.insert(
        'users',
        {
          'name': username,
          'password': password,
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro realizado com sucesso')),
      );

      // Navegar de volta para a tela de login após o registro bem-sucedido
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário já existente. Escolha outro nome de usuário.')),
      );
    }

    // Limpar os campos após o registro
    nameController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nome de Usuário',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => _register(context),
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
