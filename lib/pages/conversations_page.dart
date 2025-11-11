import 'package:flutter/material.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contatos')),
      body: const Center(child: Text('Página Contatos')),
    );
  }
}
