import 'package:flutter/material.dart';

class PanduanMitraPage extends StatelessWidget {
  const PanduanMitraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panduan Menjadi Tukang Mitra'),
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
                'assets/images/panduankanan.jpeg', // ⬅️ GAMBAR HOMEPAGE
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Cara Menjadi Tukang Mitra Teman Tukang',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9800),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Bergabunglah sebagai mitra Teman Tukang dan dapatkan peluang pekerjaan langsung dari pelanggan sesuai keahlian Anda.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),

            const SizedBox(height: 20),

            /// ===== LANGKAH-LANGKAH =====
            const Text(
              'Langkah Pendaftaran:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            _stepItem(
              number: 1,
              text: 'Hubungi tim kami via WhatsApp untuk verifikasi data.',
            ),
            _stepItem(
              number: 2,
              text:
                  'Setelah dikonfirmasi, akun akan dibuat di aplikasi Mitra Teman Tukang.',
            ),
            _stepItem(
              number: 3,
              text: 'Login menggunakan email atau nomor telepon.',
            ),
            _stepItem(
              number: 4,
              text: 'Lengkapi profil, termasuk skill dan layanan.',
            ),
            _stepItem(
              number: 5,
              text:
                  'Mulai menerima pesanan dan kelola pekerjaan dari aplikasi.',
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
                      'Pastikan data yang dikirimkan valid agar proses verifikasi berjalan cepat dan lancar.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// ===== BUTTON WHATSAPP =====
            ElevatedButton.icon(
              onPressed: () {
                // nanti bisa diarahkan ke WhatsApp
              },
              icon: const Icon(Icons.chat, color: Colors.white),
              label: const Text('Hubungi via WhatsApp'),
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

  /// ===== WIDGET STEP ITEM =====
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