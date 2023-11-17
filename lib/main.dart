import 'package:flutter/material.dart';
import 'cadastro.dart';
import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => InicioPage(),
        '/cadastro': (context) => CadastroPage(),
      },
    );
  }
}

class InicioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD8FFBE),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Adiciona a logo aqui
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 3, color: Colors.black), // Borda preta
              ),
              child: Image.asset(
                'assets/logo.png', // Substitua pelo caminho real da sua logo
                width: 250,
                height: 250,
              ),
            ),
            SizedBox(height:100), // Espaçamento entre a logo e os botões
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cadastro');
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF97E366), // Cor de fundo
                minimumSize: Size(200, 50), // Largura e altura
                side: BorderSide(width: 1, color: Colors.black), // Borda preta
              ),
              child: Text(
                'Cadastro',
                style: TextStyle(color: Colors.black), // Cor do texto preto
              ),
            ),
            SizedBox(height: 30), // Espaçamento entre os botões
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF97E366), // Cor de fundo
                minimumSize: Size(200, 50), // Largura e altura
                side: BorderSide(width: 1, color: Colors.black), // Borda preta
              ),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.black), // Cor do texto preto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
