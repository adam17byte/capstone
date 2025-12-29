import 'package:flutter/material.dart';
import '../services/api.dart';
import 'chat_room_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isLoading = true;
  List orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final result = await Api.getRiwayatOrders();
    if (!mounted) return;

    if (result['status'] == 'success') {
      setState(() {
        orders = result['data'];
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
        title: const Text('Chat'),
        backgroundColor: Colors.orange,
      ),
      body: orders.isEmpty
          ? const Center(child: Text('Belum ada chat'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, i) {
                final o = orders[i];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(o['nama']),
                  subtitle: Text(o['jenis_kerusakan']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatRoomPage(
                          orderId: o['id_order'],
                          namaLawan: o['nama'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
