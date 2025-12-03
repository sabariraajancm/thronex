import 'package:flutter/material.dart';
import 'chat_thread_model.dart';

class ChatDetailPage extends StatefulWidget {
  final ChatThread thread;

  const ChatDetailPage({super.key, required this.thread});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();

  final List<ChatMessage> _messages = [
    ChatMessage(message: "Hello!", isMe: false, time: "10:30 AM"),
    ChatMessage(
      message: "Is the phone available?",
      isMe: false,
      time: "10:30 AM",
    ),
    ChatMessage(message: "Yes, available.", isMe: true, time: "10:32 AM"),
  ];

  void sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(message: _controller.text.trim(), isMe: true, time: "Now"),
      );
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: colors.primary.withOpacity(0.15),
              child: Icon(
                widget.thread.isSeller ? Icons.storefront : Icons.person,
                color: colors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Text(widget.thread.name),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                return Align(
                  alignment: m.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: m.isMe
                          ? colors.primary.withOpacity(0.12)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      m.message,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),

          // INPUT BAR
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  onPressed: sendMessage,
                  backgroundColor: colors.primary,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
