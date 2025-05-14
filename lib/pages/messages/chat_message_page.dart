import 'package:flutter/material.dart';
import 'package:provieasy_proveedores_main/models/message.dart';
import 'package:provieasy_proveedores_main/services/message_service.dart';

class ChatMessagePage extends StatefulWidget {
  final String contractId;
  final String senderId;
  final String receiverId;
  final String providerName;
  final String contractShortId;

  const ChatMessagePage({
    Key? key,
    required this.contractId,
    required this.senderId,
    required this.receiverId,
    required this.providerName,
    required this.contractShortId,
  }) : super(key: key);

  @override
  ChatMessagePageState createState() => ChatMessagePageState();
}

class ChatMessagePageState extends State<ChatMessagePage> {
  final TextEditingController _controller = TextEditingController();
  List<Message> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final messages = await MessageService.fetchMessages(context, widget.contractId);
    setState(() {
      _messages = messages;
      _isLoading = false;
    });

    // Mark unread messages as read
    for (var msg in messages) {
      if (msg.receiverId == widget.senderId && msg.status == 1) {
        await MessageService.markMessageAsRead(context, msg.messageId);
      }
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final newMessage = await MessageService.sendMessage(
      context, widget.contractId, widget.senderId, widget.receiverId, text);
    setState(() {
      _messages.add(newMessage);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Mensajes"),
            Text(
              "${widget.providerName} - #${widget.contractShortId}",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadMessages,
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[_messages.length - 1 - index];
                        final isMine = msg.senderId == widget.senderId;
                        return Align(
                          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMine ? Colors.purple[100] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(msg.message, style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.done,
                                      size: 16,
                                      color: (msg.status == 2) ? Colors.blue : Colors.grey,
                                    ),
                                    Icon(
                                      Icons.done,
                                      size: 16,
                                      color: (msg.status == 2) ? Colors.blue : Colors.grey,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Introduce comment",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.purple),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}