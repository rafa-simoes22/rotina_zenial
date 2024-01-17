import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tarefa.dart';

class LoginPage extends StatefulWidget {
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
    print("Iniciando o processo de login...");

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
      print("Usuário e senha não estão vazios. Tentando autenticar...");

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
        print("Login bem-sucedido. Navegando para a tela de tarefas...");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login bem-sucedido')),
        );

        // Navegar para a tela de tarefas após o login bem-sucedido
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TelaPrincipal(username: username),
          ),
        );

        // Limpar os campos após o login bem-sucedido
        nameController.clear();
        passwordController.clear();
      } else {
        print("Falha no login. Verifique as credenciais.");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha no login. Verifique suas credenciais.')),
        );
      }
    } else {
      print("Usuário e/ou senha vazios. Não realizando o login.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                width: 300,
                height: 350,
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
                    SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    onChanged: (_) {
                      setState(() {
                        usernameError = ''; // Limpa a mensagem de erro ao começar a digitar
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Nome de Usuário:',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      errorText: usernameError.isEmpty ? null : usernameError,
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 30),
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
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
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
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 55),
                  ElevatedButton(
                    onPressed: () => _login(context),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF97E366),
                      minimumSize: Size(200, 50),
                      side: BorderSide(width: 0.5, color: Colors.black),
                    ),
                    child: Text(
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
      ),
    );
  }
}
