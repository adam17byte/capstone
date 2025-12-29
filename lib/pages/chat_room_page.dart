import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api.dart';

class ChatRoomPage extends StatefulWidget {
  final int orderId;
  final String namaLawan;

  const ChatRoomPage({
    super.key,
    required this.orderId,
    required this.namaLawan,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController controller = TextEditingController();
  List messages = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadChat();
    timer = Timer.periodic(const Duration(seconds: 3), (_) => loadChat());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> loadChat() async {
    final result = await Api.getChat(widget.orderId);
    if (!mounted) return;

    if (result['status'] == 'success') {
      setState(() {
        messages = result['data'];
      });
    }
  }

  Future<void> sendMessage() async {
    if (controller.text.trim().isEmpty) return;

    await Api.kirimChat(
      orderId: widget.orderId,
      message: controller.text.trim(),
    );

    controller.clear();
    loadChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.namaLawan),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final m = messages[i];
                final isMe = m['sender_role'] == 'customer';

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.orange.shade200
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(m['message']),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration:
                        const InputDecoration(hintText: 'Ketik pesan...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.orange),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
