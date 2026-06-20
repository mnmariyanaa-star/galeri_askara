import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, dynamic>> messages = [
    {'me': false, 'text': "Oh?"},
    {'me': false, 'text': "Cool"},
    {'me': false, 'text': "How does it work?"},
    {'me': true, 'text': "You just edit any text..."},
    {'me': true, 'text': "Boom!"},
    {'me': false, 'text': "Hmmmm\nI think I get it\nWill head to the Help Center if I have more questions tho"},
  ];

  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    String msg = _controller.text.trim();
    if (msg.isEmpty) return;
    setState(() {
      messages.add({'me': true, 'text': msg});
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('img/assets/kairi.png'), // Ganti dengan gambar profil
            ),
            const SizedBox(width: 8),
            const Text("Helena Hills", style: TextStyle(color: Colors.black)),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.phone), onPressed: (){}),
          IconButton(icon: const Icon(Icons.videocam), onPressed: (){}),
        ],
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final m = messages[i];
                final bool isMe = m['me'] as bool;
                final String text = m['text'] as String;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isMe ? 16 : 4),
                        topRight: Radius.circular(isMe ? 4 : 16),
                        bottomLeft: const Radius.circular(16),
                        bottomRight: const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      text,
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                          fontSize: 16
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Chat Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.add_a_photo, color: Colors.blue),
                    onPressed: () {
                      // Implement foto upload jika mau
                    }
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Message...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18))
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    ),
                    onSubmitted: (val) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
