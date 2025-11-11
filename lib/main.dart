import 'package:flutter/material.dart';
import 'widgets/app_navigation_rail.dart';
import 'pages/chat_page.dart';
import 'pages/conversations_page.dart';
import 'pages/settings_page.dart';

// Ajuste os comprimentos das colunas mudando estes valores (flex)
const double leftFlex = 2;
const double middleFlex = 3;
const double rightFlex = 10;

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
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Coluna esquerda: largura fixa para garantir espaço ao NavigationRail
            SizedBox(
              width: 80,
              child: AppNavigationRail(
                selectedIndex: _selectedIndex,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.chat),
                    selectedIcon: Icon(Icons.chat_bubble),
                    label: Text('Chats'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.group_outlined),
                    selectedIcon: Icon(Icons.group),
                    label: Text('Contatos'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                    label: Text('Ajustes'),
                  ),
                ],
                // exemplo de ícone manual acima da rail
                leading: FloatingActionButton(
                  elevation: 0,
                  onPressed: () {
                    // ação do botão manual
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Botão manual pressionado')));
                  },
                  mini: true,
                  child: const Icon(Icons.add),
                ),
                // exemplo de trailing (abaixo da rail)
                trailing: IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trailing pressionado')));
                  },
                  icon: const Icon(Icons.more_horiz_rounded),
                ),
                onDestinationSelected: (index) {
                  // Atualiza seleção localmente (pai controla a seleção)
                  setState(() => _selectedIndex = index);

                  // Ao clicar em Chats, sempre abrir a página `ChatsPage`.
                  if (index == 0) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ChatsPage(),
                      ),
                    );
                    return;
                  }

                  // Outros destinos abrem suas páginas
                  if (index == 1) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ConversationsPage(),
                      ),
                    );
                  } else if (index == 2) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SettingsPage(),
                      ),
                    );
                  }
                },
              ),
            ),
            Expanded(
              flex: (middleFlex * 10).round(),
              child: Container(
                color: Colors.green,
                child: Center(
                  child: _buildCenterContent(),
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

  // Conteúdo do centro que muda conforme a seleção
  Widget _buildCenterContent() {
    switch (_selectedIndex) {
      case 0:
        return const Text('Chats', style: TextStyle(color: Colors.white, fontSize: 18));
      case 1:
        return const Text('Contatos', style: TextStyle(color: Colors.white, fontSize: 18));
      case 2:
        return const Text('Ajustes', style: TextStyle(color: Colors.white, fontSize: 18));
      default:
        return const Text('Coluna 2', style: TextStyle(color: Colors.white));
    }
  }
}
