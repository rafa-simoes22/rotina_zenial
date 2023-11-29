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
  final TextEditingController confirmPasswordController = TextEditingController();

  String usernameError = '';
  String passwordError = '';
  String confirmPasswordError = '';

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Faça seu cadastro',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFF97E366),
      ),
      backgroundColor: Color(0xFFD8FFBE),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                width: 300,
                height: 380,
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
                    SizedBox(height: 10),
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
                            obscurePassword ? Icons.visibility : Icons.visibility_off, // Alterando ícone para olho fechado
                            color: Colors.green, // Alterando a cor do ícone para verde
                          ),
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: confirmPasswordController,
                      onChanged: (_) {
                        setState(() {
                          confirmPasswordError = ''; // Limpa a mensagem de erro ao começar a digitar
                        });
                      },
                      obscureText: obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha:',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                        errorText: confirmPasswordError.isEmpty ? null : confirmPasswordError,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                          icon: Icon(
                            obscureConfirmPassword ? Icons.visibility : Icons.visibility_off, // Alterando ícone para olho fechado
                            color: Colors.green, // Alterando a cor do ícone para verde
                          ),
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 50), // Adicionado margin-top para centralizar o botão
                    ElevatedButton(
                      onPressed: () {
                        // Validação dos campos
                        final String username = nameController.text;
                        final String password = passwordController.text;
                        final String confirmPassword = confirmPasswordController.text;

                        if (username.isEmpty) {
                          setState(() {
                            usernameError = 'Por favor, digite um nome de usuário.';
                          });
                        }

                        if (password.isEmpty) {
                          setState(() {
                            passwordError = 'Por favor, digite uma senha.';
                          });
                        } else {
                          // Validação da senha
                          if (password.length != 8) {
                            setState(() {
                              passwordError = 'A senha deve ter exatamente 8 caracteres.';
                            });
                          } else if (!RegExp(r'[a-zA-Z]').hasMatch(password)) {
                            setState(() {
                              passwordError = 'Adicione pelo menos 1 letra.';
                            });
                          } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
                            setState(() {
                              passwordError = 'Adicione pelo menos 1 caracter especial.';
                            });
                          }
                        }

                        if (confirmPassword != password) {
                          setState(() {
                            confirmPasswordError = 'As senhas não coincidem.';
                          });
                        }

                        if (username.isNotEmpty &&
                            password.isNotEmpty &&
                            password.length == 8 &&
                            RegExp(r'[a-zA-Z]').hasMatch(password) &&
                            RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password) &&
                            confirmPassword == password) {
                          // Se os campos são válidos, continue com o registro
                          _register(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF97E366),
                        minimumSize: Size(200, 50),
                        side: BorderSide(width: 0.5, color: Colors.black),
                      ),
                      child: Text(
                        'Cadastrar',
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
    confirmPasswordController.clear();
  }
}
