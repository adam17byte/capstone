import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'chat_room_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      {'name': 'Ahmad Imam', 'message': 'Hai, tukang saya perbaiki bocor', 'time': '18:30'},
      {'name': 'Budi', 'message': 'Siap, kapan bisa datang?', 'time': '19:00'},
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: const Color(0xFFFF9800),
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari tukang...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Daftar chat
            Expanded(
              child: ListView.separated(
                itemCount: chats.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final c = chats[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      c['name']!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      c['message']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: Text(
                      c['time']!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () {
                      // pindah ke halaman room chat
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatRoomPage(
                            chatName: c['name']!
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }
}
