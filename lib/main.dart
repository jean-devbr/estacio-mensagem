import 'package:flutter/material.dart';
import 'pages/chat_page.dart';

// Ajuste os comprimentos das colunas mudando estes valores (flex)
const double leftFlex = 0.04;
const double middleFlex = 0.10;
const double rightFlex = 0.5;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Mensagem',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF075E54)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

/// Tela inicial mínima que só mostra opções de navegação para as páginas
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        child: Row(
          children: [
            // converte double proporcional em int para a propriedade `flex`
            Expanded(
              flex: (leftFlex * 10).round(),
              child: Container(
                color: Colors.red,
                child: const Center(
                  child: Text('Coluna 1', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Expanded(
              flex: (middleFlex * 10).round(),
              child: Container(
                color: Colors.green,
                child: const Center(
                  child: Text('Coluna 2', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Expanded(
              flex: (rightFlex * 10).round(),
              child: Container(
                color: Colors.blue,
                child: const Center(
                  child: Text('Coluna 3', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
