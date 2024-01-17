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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/inicio.png'), 
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 16),
              ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, '/cadastro');
  },
  style: ElevatedButton.styleFrom(
    primary: Color(0xFFDFFF9E), // Cor do botão de cadastro
    minimumSize: Size(200, 50),
    side: BorderSide(width: 0.5, color: Colors.black),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Ajuste o raio conforme necessário
    ),
    elevation: 2.0, // Ajuste o valor conforme necessário para a intensidade da sombra

  ),
  child: Text(
    'Cadastro',
    style: TextStyle(color: Color(0xFF293D01)), // Cor do texto de cadastro
  ),
),
              SizedBox(height: 16),
             ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  },
  style: ElevatedButton.styleFrom(
    primary: Color(0xF568200), // Cor do botão
    minimumSize: Size(200, 50),
    
    side: BorderSide(width: 0.5, color: Colors.black),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Ajuste o raio conforme necessário
    ),
    elevation: 2.0, // Ajuste o valor conforme necessário para a intensidade da sombra
  ),
  child: Text(
    'Login',
    style: TextStyle(color: Color(0xFFDFFF9E),), // Cor do texto
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}
