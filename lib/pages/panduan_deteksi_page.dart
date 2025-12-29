import 'package:flutter/material.dart';
import 'deteksi_page.dart';

class PanduanDeteksiPage extends StatelessWidget {
  const PanduanDeteksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panduan Deteksi Kerusakan'),
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        backgroundColor: const Color(0xFFFF9800),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            /// ===== HEADER (SAMA DENGAN HOMEPAGE) =====
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                'assets/images/panduankiri.jpeg',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Cara Memesan Tukang dengan Fitur Deteksi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9800),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Gunakan fitur deteksi untuk membantu Anda mengetahui jenis kerusakan bangunan dan memberikan rekomendasi tukang yang sesuai secara otomatis.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),

            const SizedBox(height: 20),

            /// ===== LANGKAH-LANGKAH =====
            const Text(
              'Langkah Penggunaan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            _stepItem(
              number: 1,
              text: 'Buka aplikasi Teman Tukang dan pilih menu Deteksi.',
            ),
            _stepItem(
              number: 2,
              text:
                  'Masuk ke halaman deteksi, lalu unggah gambar kerusakan bangunan yang ingin diperbaiki.',
            ),
            _stepItem(
              number: 3,
              text: 'Tekan tombol Deteksi untuk memulai analisis kerusakan.',
            ),
            _stepItem(
              number: 4,
              text: 'Aplikasi akan menampilkan hasil analisis kerusakan.',
            ),
            _stepItem(
              number: 5,
              text:
                  'Dari hasil deteksi, aplikasi menampilkan rekomendasi tukang sesuai faktor kerusakan.',
            ),
            _stepItem(
              number: 6,
              text:
                  'Klik salah satu tukang untuk melihat profil dan pengalaman mereka.',
            ),
            _stepItem(
              number: 7,
              text:
                  'Jika sudah yakin, tekan tombol Pesan Sekarang untuk memesan tukang.',
            ),
            _stepItem(
              number: 8,
              text:
                  'Jika ingin konsultasi dulu, gunakan tombol Chat untuk berkomunikasi dengan tukang.',
            ),

            const SizedBox(height: 24),

            /// ===== CATATAN =====
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Color(0xFFFF9800)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pastikan foto kerusakan terlihat jelas agar hasil deteksi lebih akurat.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// ===== BUTTON CTA =====
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DeteksiPage()),
                );
              },
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label: const Text('Coba Deteksi Sekarang'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _stepItem({required int number, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFFFF9800),
            child: Text(
              '$number',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}