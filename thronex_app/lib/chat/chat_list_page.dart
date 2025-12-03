import 'package:flutter/material.dart';
import 'chat_thread_model.dart';
import 'chat_detail_page.dart';

class ChatListPage extends StatelessWidget {
  ChatListPage({super.key});

  final List<ChatThread> threads = [
    ChatThread(
      id: "1",
      name: "Royal Mobiles",
      lastMessage: "Sure, pickup available!",
      time: "11:45 AM",
      unread: true,
      isSeller: true,
    ),
    ChatThread(
      id: "2",
      name: "Prakash",
      lastMessage: "Can you reduce price?",
      time: "10:10 AM",
      unread: false,
      isSeller: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      body: ListView.builder(
        itemCount: threads.length,
        itemBuilder: (context, i) {
          final t = threads[i];
          return ListTile(
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: colors.primary.withOpacity(0.15),
              child: Icon(
                t.isSeller ? Icons.storefront : Icons.person,
                color: colors.primary,
              ),
            ),
            title: Text(
              t.name,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              t.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(t.time, style: const TextStyle(fontSize: 11)),
                if (t.unread)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChatDetailPage(thread: t)),
              );
            },
          );
        },
      ),
    );
  }
}
