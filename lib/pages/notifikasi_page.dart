import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api.dart';
import '../services/socket_service.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  final SocketService _socket = SocketService();
  List<Map<String, dynamic>> notifikasi = [];
  bool isLoading = true;
  String? jwt;

  @override
  void initState() {
    super.initState();
    _init();
  }

  // ================= INIT =================
  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    jwt = prefs.getString("jwt");

    await _loadHistory();

    if (jwt != null) {
      _initSocket();
    }
  }

  // ================= LOAD HISTORY =================
  Future<void> _loadHistory() async {
    final res = await Api.getNotifikasi();
    if (!mounted) return;

    if (res["status"] == "success") {
      notifikasi = List<Map<String, dynamic>>.from(res["data"]);
    }

    setState(() {
      isLoading = false;
    });
  }

  // ================= SOCKET =================
  void _initSocket() {
    _socket.connect(
      baseUrl: "https://witted-gentler-jeanett.ngrok-free.dev",
      token: jwt!,
      onConnected: () {
        _socket.onNotifikasi((data) {
          if (!mounted) return;

          setState(() {
            notifikasi.insert(0, {
              "judul": data["judul"],
              "isi": data["isi"],
              "created_at": data["created_at"],
            });
          });
        });
      },
    );
  }

  @override
  void dispose() {
    _socket.disconnect();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikasi"),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifikasi.isEmpty
              ? const Center(child: Text("Belum ada notifikasi"))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifikasi.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final n = notifikasi[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.notifications,
                          color: Colors.orange,
                        ),
                        title: Text(n["judul"]),
                        subtitle: Text(n["isi"]),
                      ),
                    );
                  },
                ),
    );
  }
}