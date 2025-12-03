class ChatThread {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final bool unread;
  final bool isSeller;

  ChatThread({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.isSeller,
  });
}

class ChatMessage {
  final String message;
  final bool isMe;
  final String time;

  ChatMessage({required this.message, required this.isMe, required this.time});
}
