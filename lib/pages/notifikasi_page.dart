import 'package:flutter/material.dart';
import '../services/api.dart';
import '../services/socket_service.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  final SocketService _socket = SocketService();
  List notifikasi = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _listenSocket();
  }

  Future<void> _load() async {
    final res = await Api.getNotifikasi();
    if (res["status"] == "success") {
      setState(() {
        notifikasi = res["data"];
        isLoading = false;
      });
    }
  }

  void _listenSocket() {
    _socket.onNotifikasi((data) {
      setState(() {
        notifikasi.insert(0, {
          "judul": data["judul"],
          "isi": data["isi"],
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikasi"),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifikasi.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final n = notifikasi[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.notifications, color: Colors.orange),
                    title: Text(n["judul"]),
                    subtitle: Text(n["isi"]),
                  ),
                );
              },
            ),
    );
  }
}
