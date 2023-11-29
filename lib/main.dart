import 'package:flutter/material.dart';
import 'cadastro.dart';
import 'login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const InicioPage(),
        '/cadastro': (context) => const CadastroPage(),
      },
    );
  }
}

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8FFBE),
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
            const SizedBox(height:100), // Espaçamento entre a logo e os botões
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cadastro');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF97E366), // Cor de fundo
                minimumSize: const Size(200, 50), // Largura e altura
                side: const BorderSide(width: 1, color: Colors.black), // Borda preta
              ),
              child: const Text(
                'Cadastro',
                style: TextStyle(color: Colors.black), // Cor do texto preto
              ),
            ),
            const SizedBox(height: 30), // Espaçamento entre os botões
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF97E366), // Cor de fundo
                minimumSize: const Size(200, 50), // Largura e altura
                side: const BorderSide(width: 1, color: Colors.black), // Borda preta
              ),
              child: const Text(
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
