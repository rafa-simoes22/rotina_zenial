import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoções App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EmotionsScreen(),
    );
  }
}

class EmotionsScreen extends StatefulWidget {
  @override
  _EmotionsScreenState createState() => _EmotionsScreenState();
}

class _EmotionsScreenState extends State<EmotionsScreen> {
  String? selectedEmotion; // Default: None selected
  Color backgroundColor = Colors.white;
  Color fontColor = Colors.black;
  String currentMessage = "Selecione uma opção"; // Default message

  void updateEmotion(String emotion, String message) {
    setState(() {
      selectedEmotion = emotion;
      currentMessage = message; // Update the message based on the emotion
      switch (emotion) {
        case "Amigável":
          backgroundColor = Colors.orange;
          fontColor = Colors.white;
          break;
        case "Em paz":
          backgroundColor = Colors.green;
          fontColor = Colors.white;
          break;
        case "Confiante":
          backgroundColor = Colors.blue;
          fontColor = Colors.white;
          break;
        case "Animado":
          backgroundColor = Colors.yellow;
          fontColor = Colors.black;
          break;
        default:
          backgroundColor = Colors.white;
          fontColor = Colors.black;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emoções App'),
      ),
      body: Container(
        color: backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButton<String>(
                hint: Text("Selecione"), // Initial hint
                value: selectedEmotion,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    String message = ""; // Default message for the selected emotion
                    switch (newValue) {
                      case "Amigável":
                        message = "Você está se sentindo amigável.";
                        break;
                      case "Em paz":
                        message = "Você está se sentindo em paz.";
                        break;
                      case "Confiante":
                        message = "Você está se sentindo confiante.";
                        break;
                      case "Animado":
                        message = "Você está se sentindo animado.";
                        break;
                    }
                    updateEmotion(newValue, message);
                  }
                },
                items: <String>[
                  'Amigável',
                  'Em paz',
                  'Confiante',
                  'Animado',
                ].map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
              SizedBox(height: 20),
              Text(
                currentMessage,
                style: TextStyle(
                  color: fontColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
