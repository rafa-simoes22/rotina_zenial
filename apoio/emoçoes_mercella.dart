import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

//arquivo json nas dependencias

void main() => runApp(MyDiaryApp());

class MyDiaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(0, 38, 199, 16), // Define a cor de fundo
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Adicione um espaço para a logo aqui
          Image.asset(
            'assets/logo_rotinazenial.jpg', // Substitua pelo caminho da sua logo
            width: 150, // Ajuste o tamanho da imagem conforme necessário
            height: 150,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF7CBF6A), // Define a cor do botão
              fixedSize: Size(200, 50), // Define o tamanho fixo do botão
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20), // Espaço entre os botões
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF7CBF6A), // Define a cor do botão
              fixedSize: Size(200, 50), // Define o tamanho fixo do botão
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Cadastro',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class User {
  final String username;
  final String password;

  User(this.username, this.password);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['username'], json['password']);
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}

class DiaryEntry {
  final String username;
  final String text;

  DiaryEntry(this.username, this.text);

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(json['username'], json['text']);
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'text': text};
  }
}

class UserManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/diary.json');
  }

  Future<void> saveDiaryEntry(String username, String text) async {
    final diaryEntry = DiaryEntry(username, text);
    final file = await _localFile;
    final List<dynamic> existingEntries = await getDiaryEntries();

    existingEntries.add(diaryEntry.toJson());
    await file.writeAsString(json.encode(existingEntries));
  }

  Future<List<DiaryEntry>> getDiaryEntries() async {
    try {
      final file = await _localFile;
      final exists = await file.exists();
      if (!exists) {
        return [];
      }
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => DiaryEntry.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addUser(User user) async {
    final users = await getUsers();
    users.add(user);

    final file = await _localFile;
    final jsonList = users.map((user) => user.toJson()).toList();
    await file.writeAsString(json.encode(jsonList));
  }

  Future<List<User>> getUsers() async {
    try {
      final file = await _localFile;
      final exists = await file.exists();
      if (!exists) {
        return [];
      }
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> validateUser(String username, String password) async {
    final users = await getUsers();
    try {
      final matchingUser = users.firstWhere(
        (user) => user.username == username && user.password == password,
      );

      // Se o usuário for encontrado, retorna true
      return true;
    } catch (e) {
      // Se nenhum usuário correspondente for encontrado, lança uma exceção
      throw Exception('Usuário não encontrado');
    }
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserManager userManager = UserManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Nome de Usuário'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final username = usernameController.text;
                final password = passwordController.text;
                try {
                  final isValidUser = await userManager.validateUser(username, password);
                  if (isValidUser) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DiaryScreen(username)),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Erro de login'),
                          content: Text('Nome de usuário ou senha incorretos.'),
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
                  }
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Erro de login'),
                        content: Text('Ocorreu um erro inesperado: $e'),
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
                }
              },
              child: Text('Fazer Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserManager userManager = UserManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Nome de Usuário'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final username = usernameController.text;
                final password = passwordController.text;
                final user = User(username, password);
                try {
                  await userManager.addUser(user);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Cadastro bem-sucedido'),
                        content: Text('Seu cadastro foi realizado com sucesso!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pop(context); // Voltar para a tela de login
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Erro de cadastro'),
                        content: Text('Ocorreu um erro inesperado ao cadastrar: $e'),
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
                }
              },
              child: Text('Cadastrar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}

class DiaryScreen extends StatefulWidget {
  final String username;

  DiaryScreen(this.username);

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final UserManager userManager = UserManager();
  String emojiDescription = '';

  void _showEmojiDescription(String emoji) {
    setState(() {
      switch (emoji) {
        case '😃':
          emojiDescription = 'Aproveite cada momento de alegria, pois são esses momentos que fazem a vida valer a pena';
          break;
        case '😢':
          emojiDescription = 'Lembre-se de que a tristeza é apenas uma nuvem passageira no céu da sua vida. O sol sempre volta a brilhar';
          break;
        case '😐':
          emojiDescription = 'É completamente normal ter altos e baixos na vida. A jornada é feita de todos esses momentos, e todos eles têm seu valor';
          break;
        default:
          emojiDescription = '';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diário'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bem-vindo, ${widget.username}!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text('Voltar'),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              color: Theme.of(context).primaryColor, // Define a mesma cor da AppBar
              child: Column(
                children: [
                  Text(
                    'Como você está se sentindo?',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.black, // Define a cor do texto para branco
                    ),
                    textAlign: TextAlign.center, // Centraliza o texto
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showEmojiDescription('😃'); // Mostrar descrição feliz
                        },
                        child: Text(
                          '😃',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showEmojiDescription('😢'); // Mostrar descrição triste
                        },
                        child: Text(
                          '😢',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showEmojiDescription('😐'); // Mostrar descrição normal
                        },
                        child: Text(
                          '😐',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    emojiDescription, // Exibe a descrição com base na seleção do emoji
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
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
