import 'package:flutter/material.dart';
import '../services/api.dart';
import 'rating_ulasan_page.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  bool isLoading = true;
  String error = '';
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
    } else {
      setState(() {
        error = result['message'] ?? 'Gagal memuat riwayat';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat Pesanan'),
          backgroundColor: Colors.orange,
        ),
        body: Center(child: Text(error)),
      );
    }

    if (orders.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat Pesanan'),
          backgroundColor: Colors.orange,
        ),
        body: const Center(child: Text('Belum ada pesanan')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, i) {
          final o = orders[i];
          final status = o['status'];
          final isSelesai = status == 'selesai';

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    o['jenis_kerusakan'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text("Tukang: ${o['nama']}"),
                  Text("Status: $status"),

                  if (isSelesai)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RatingUlasanPage(
                                tukangName: o['nama'],
                              ),
                            ),
                          );
                        },
                        child: const Text("Beri Ulasan"),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
