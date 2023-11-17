import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tarefa.dart'; // Importe a tela principal

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
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

    final List<Map<String, dynamic>> users = await database.query(
      'users',
      where: 'name = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (users.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login bem-sucedido')),
      );

      // Navegar para a tela de tarefas após o login bem-sucedido
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TelaPrincipal(username: username), // Passe o nome de usuário
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha no login. Verifique suas credenciais.')),
      );
    }

    // Limpar os campos após a tentativa de login
    nameController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faça seu Login:',
         style: TextStyle(color: Colors.black)), // Cor do texto preto
        backgroundColor: Color(0xFF97E366), // Cor da AppBar
      ),
      backgroundColor: Color(0xFFD8FFBE), // Cor do scaffold
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Container(
              // Container para os inputs com background verde (#6aa076)
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              width: 300, // Defina a largura desejada
              height: 350, // Defina a altura desejada
              decoration: BoxDecoration(
                color: Color(0xFFFE6F4DE),
                border: Border(
        top: BorderSide(color: Color(0xFF243618)),
        left: BorderSide(color: Color(0xFF243618)),
        right: BorderSide(color: Color(0xFF243618)),
        bottom: BorderSide(color: Color(0xFF243618)),
      ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10), // Espaçamento entre os inputs

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome de Usuário:',
                     focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green), // Cor da linha quando focado
                    ),
                    labelStyle: TextStyle(color: Colors.black), // Cor do texto do placeholder
                    ),
                    style: TextStyle(color: Colors.black), // Cor do texto preto
                    ),
                  SizedBox(height: 30), // Espaçamento entre os inputs
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha:',
                    focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green), // Cor da linha quando focado
                    ),
                    labelStyle: TextStyle(color: Colors.black), // Cor do texto do placeholder
                    ),
                    style: TextStyle(color: Colors.black), // Cor do texto preto
                    ),
                   SizedBox(height: 80), // Espaçamento entre os inputs e o botão
                  ElevatedButton(
                onPressed: () => _login(context),
                style: ElevatedButton.styleFrom(
                primary: Color(0xFF97E366), // Cor de fundo
                minimumSize: Size(200, 50), // Largura e altura
                side: BorderSide(width: 0.5, color: Colors.black), // Borda preta
              ),
              child: Text(
                'Fazer Login',
                style: TextStyle(color: Colors.black), // Cor do texto preto
              ),
            ),
                ], 
              ),
            ),
           
            
          ],
        ),
      ),
    );
  }
}










