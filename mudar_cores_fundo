import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'How Do You Feel Today?',
      theme: ThemeData(
        primarySwatch: MyColors.customColor,
      ),
      home: MyHomePage(),
    );
  }
}

class MyColors {
  static MaterialColor customColor = MaterialColor(
    0xFFCF93A7,
    <int, Color>{
      50: Color(0xFFCF93A7),
      100: Color(0xFFCF93A7),
      200: Color(0xFFCF93A7),
      300: Color(0xFFCF93A7),
      400: Color(0xFFCF93A7),
      500: Color(0xFFCF93A7),
      600: Color(0xFFCF93A7),
      700: Color(0xFFCF93A7),
      800: Color(0xFFCF93A7),
      900: Color(0xFFCF93A7),
    },
  );
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedOption = "";
  Color backgroundColor = Color.fromARGB(255, 240, 180, 215);

  Map<String, Color?> optionColors = {
    'Amigável': Color.fromARGB(255, 241, 160, 92),
    'Em paz': Color.fromARGB(255, 145, 206, 235),
    'Confiante': Color.fromARGB(255, 121, 238, 125),
    'Animado': Color.fromARGB(255, 245, 231, 108),
  };

  void _updateBackgroundAndSelection(String option) {
    setState(() {
      selectedOption = option;
      backgroundColor = optionColors[option] ?? Colors.pink[50]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('How Do You Feel Today?', style: TextStyle(fontSize: 24),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Como você se sente hoje?',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10), // Espaço entre o texto e o DropdownButton
            DropdownButton<String>(
              value: selectedOption,
              onChanged: (String? newValue) {
                _updateBackgroundAndSelection(newValue!);
              },
              items: <String>[
                '',
                'Amigável',
                'Em paz',
                'Confiante',
                'Animado',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20), // Espaço entre o DropdownButton e o Text da seleção
            Text(
              'Seleção: $selectedOption',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
