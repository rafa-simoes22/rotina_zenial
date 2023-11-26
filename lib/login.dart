import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tarefa.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String usernameError = '';
  String passwordError = '';

  bool obscurePassword = true;

  Future<void> _login(BuildContext context) async {
    final String username = nameController.text;
    final String password = passwordController.text;

    if (username.isEmpty) {
      setState(() {
        usernameError = 'Por favor, digite um nome de usuário.';
      });
    } else {
      setState(() {
        usernameError = '';
      });
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = 'Por favor, digite uma senha.';
      });
    } else {
      setState(() {
        passwordError = '';
      });
    }

    if (username.isNotEmpty && password.isNotEmpty) {
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
          const SnackBar(content: Text('Login bem-sucedido')),
        );

        // Navegar para a tela de tarefas após o login bem-sucedido
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TelaPrincipal(username: username),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha no login. Verifique suas credenciais.')),
        );
      }

      // Limpar os campos após a tentativa de login
      nameController.clear();
      passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Faça seu Login:',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFF97E366),
      ),
      backgroundColor: const Color(0xFFD8FFBE),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              width: 300,
              height: 350,
              decoration: const BoxDecoration(
                color: Color(0xfffe6f4de),
                border: Border(
                  top: BorderSide(color: Color(0xFF243618)),
                  left: BorderSide(color: Color(0xFF243618)),
                  right: BorderSide(color: Color(0xFF243618)),
                  bottom: BorderSide(color: Color(0xFF243618)),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    onChanged: (_) {
                      setState(() {
                        usernameError = ''; // Limpa a mensagem de erro ao começar a digitar
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Nome de Usuário:',
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelStyle: const TextStyle(color: Colors.black),
                      errorText: usernameError.isEmpty ? null : usernameError,
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: passwordController,
                    onChanged: (_) {
                      setState(() {
                        passwordError = ''; // Limpa a mensagem de erro ao começar a digitar
                      });
                    },
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Senha:',
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelStyle: const TextStyle(color: Colors.black),
                      errorText: passwordError.isEmpty ? null : passwordError,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 55),
                  ElevatedButton(
                    onPressed: () => _login(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF97E366),
                      minimumSize: const Size(200, 50),
                      side: const BorderSide(width: 0.5, color: Colors.black),
                    ),
                    child: const Text(
                      'Fazer Login',
                      style: TextStyle(color: Colors.black),
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
