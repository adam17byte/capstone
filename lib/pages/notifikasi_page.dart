import 'package:flutter/material.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifikasi = [
      {'judul': 'Pesanan Diterima', 'isi': 'Pesanan Anda sudah diterima tukang.'},
      {'judul': 'Tukang Sedang Dalam Perjalanan', 'isi': 'Tukang akan tiba dalam 10 menit.'},
      {'judul': 'Selesai', 'isi': 'Pekerjaan telah diselesaikan dengan baik.'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: const Color(0xFFFF9800),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifikasi.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = notifikasi[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.notifications_active,
                  color: Colors.orange),
              title: Text(
                item['judul']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item['isi']!),
            ),
          );
        },
      ),
    );
  }
}
