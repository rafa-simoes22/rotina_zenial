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
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 3, color: Colors.black),
              ),
              child: Image.asset(
                'assets/logo.png',
                width: 250,
                height: 250,
              ),
            ),
            SizedBox(height: 16), // Use relative spacing
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cadastro');
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF97E366),
                minimumSize: Size(200, 50),
                side: BorderSide(width: 1, color: Colors.black),
              ),
              child: Text(
                'Cadastro',
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 16), // Use relative spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF97E366),
                minimumSize: Size(200, 50),
                side: BorderSide(width: 1, color: Colors.black),
              ),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
