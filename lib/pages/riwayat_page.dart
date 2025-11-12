import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'rating_ulasan_page.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {
        'title': 'Perbaikan Pipa Bocor',
        'tukang': 'Ahmad Imam',
        'date': '12 Nov 2025',
        'status': 'Selesai',
      },
      {
        'title': 'Perbaikan Listrik',
        'tukang': 'Budi Santoso',
        'date': '02 Okt 2025',
        'status': 'Dalam Proses',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        backgroundColor: const Color(0xFFFF9800),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, i) {
          final o = orders[i];
          final isSelesai = o['status'] == 'Selesai';

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === Baris atas: judul & status ===
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          o['title']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelesai ? Colors.green.shade50 : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          o['status']!,
                          style: TextStyle(
                            color: isSelesai ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),
                  Text('Tukang: ${o['tukang']}', style: TextStyle(color: Colors.grey[700])),
                  Text('Tanggal: ${o['date']}', style: TextStyle(color: Colors.grey[600])),

                  // === Baris bawah: tombol beri rating ===
                  if (isSelesai) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RatingUlasanPage(
                                tukangName: o['tukang']!,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9800), // Oranye
                          foregroundColor: Colors.white, // Teks & ikon putih
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          elevation: 2,
                        ),
                        label: const Text(
                          'Beri Rating & Ulasan',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}