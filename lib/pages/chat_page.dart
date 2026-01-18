import 'package:flutter/material.dart';
import '../services/api.dart';
import 'chat_room_page.dart';
import '../widgets/bottom_nav.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isLoading = true;
  List chats = [];
  String error = "";

  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  Future<void> fetchChats() async {
    final result = await Api.getHomePesanan(); // kita buat helper ini
    if (!mounted) return;

    if (result["status"] == "success") {
      setState(() {
        chats = result["data"];
        isLoading = false;
      });
    } else {
      setState(() {
        error = result["message"];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        backgroundColor: Colors.orange,
      ),
      body: chats.isEmpty
          ? const Center(child: Text("Belum ada chat"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final c = chats[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(c["nama_tukang"]),
                  subtitle: Text("Status: ${c["status"]}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatRoomPage(
                          pesananId: c["id_pesanan"],
                          chatName: c["nama_tukang"],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }
}