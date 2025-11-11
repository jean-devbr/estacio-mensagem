import 'package:flutter/material.dart';

// ========================= MODELOS =========================
class Contact {
  final String name;
  final String subtitle;
  final String avatarUrl;
  final String time;
  final int unread;

  const Contact({
    required this.name,
    required this.subtitle,
    required this.avatarUrl,
    required this.time,
    this.unread = 0,
  });
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  ChatMessage({required this.text, required this.isMe, required this.time});
}

/// Tela de chat
class ChatPage extends StatefulWidget {
  final String title;

  const ChatPage({super.key, required this.title});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mensagens de exemplo
  final List<ChatMessage> _messages = [
    ChatMessage(text: 'Beleza, combinado 👍', isMe: true, time: '18:34'),
    ChatMessage(text: 'Fechado, até mais!', isMe: false, time: '18:33'),
    ChatMessage(text: 'Podemos marcar pra amanhã?', isMe: false, time: '18:32'),
    ChatMessage(text: 'Oi! Tudo bem?', isMe: false, time: '18:30'),
    ChatMessage(text: 'Fala! Tudo certo e você?', isMe: true, time: '18:31'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.insert(
        0,
        ChatMessage(text: text, isMe: true, time: _formattedTime()),
      );
    });
    _controller.clear();

    // rolar para a última mensagem (lista está invertida)
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  String _formattedTime() {
    final now = TimeOfDay.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD), // parecido com WhatsApp
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?img=3', // só para exemplo
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const Text('online', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: const [
          Icon(Icons.videocam),
          SizedBox(width: 16),
          Icon(Icons.call),
          SizedBox(width: 16),
          Icon(Icons.more_vert),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Lista de mensagens
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true, // mensagem nova fica embaixo visualmente
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ChatBubble(message: msg);
              },
            ),
          ),

          // Campo de digitação
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              color: const Color(0xFFEDEDED),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Mensagem',
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF075E54),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bolha de mensagem em estilo WhatsApp
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    final bgColor = isMe
        ? const Color(0xFFDCF8C6) // verde claro do WhatsApp
        : Colors.white;
    final align = isMe ? Alignment.centerRight : Alignment.centerLeft;
    final crossAxis = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
      bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
    );

    return Align(
      alignment: align,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                blurRadius: 1,
                spreadRadius: 0.2,
                // withOpacity foi descontinuado nas versões recentes; use withValues
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: crossAxis,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message.text, style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: isMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Text(
                    message.time,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.done_all,
                      size: 16,
                      color: Colors.blue.shade400, // lido
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========================= APP / ENTRYPOINT =========================
/// Função principal: sem ela o Flutter Web não encontra o ponto de entrada e
/// gera erro parecido com "Undefined name 'main'".
void main() {
  runApp(const MyApp());
}

/// Widget raiz que configura tema e define a primeira tela como [ChatPage].
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
      home: const ConversationsPage(),
    );
  }
}

/// Lista de conversas; ao tocar, navega para [ChatPage]
class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  List<Contact> _contacts() => const [
    Contact(
      name: 'Minha vida',
      subtitle: 'Oi! Tudo bem?',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      time: '18:30',
      unread: 2,
    ),
    Contact(
      name: 'Jean',
      subtitle: 'Beleza, combinado 👍',
      avatarUrl: 'https://i.pravatar.cc/150?img=15',
      time: '18:34',
    ),
    Contact(
      name: 'Grupo Estácio',
      subtitle: 'Até amanhã!',
      avatarUrl: 'https://i.pravatar.cc/150?img=20',
      time: '17:10',
      unread: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final items = _contacts();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversas'),
        backgroundColor: const Color(0xFF075E54),
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final c = items[index];
          return ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(c.avatarUrl)),
            title: Text(c.name),
            subtitle: Text(c.subtitle),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(c.time, style: const TextStyle(fontSize: 12)),
                if (c.unread > 0)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF25D366),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Text(
                      '${c.unread}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ChatPage(title: c.name)),
              );
            },
          );
        },
      ),
    );
  }
}
