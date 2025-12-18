import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'deteksi_page.dart';
import 'chatbot_page.dart';
import 'notifikasi_page.dart';
import 'artikel_kerusakan_awal_page.dart';
import 'artikel_renovasi_aman_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Transform.scale(
              scale: 2.5,
              child: Image.asset(
                'assets/images/logo_temantukang.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_active_outlined),
              tooltip: 'Notifikasi',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotifikasiPage()),
                );
              },
            ),
          ],
        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// ===========================
              /// BANNER
              /// ===========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 230,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://assets.promediateknologi.id/crop/0x0:0x0/750x500/webp/photo/2023/02/11/969053708.jpeg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: 230,
                        width: double.infinity,
                        color: Colors.black54,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Selamat Datang!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Text(
                                'Temukan layanan tukang profesional dan terpercaya untuk segala kebutuhan perbaikan rumahmu.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// ===========================
              /// PANDUAN PENGGUNAAN
              /// ===========================
              const Center(
                child: Text(
                  'Panduan Penggunaan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _panduanDetailCard(
                        image: 'assets/images/panduankiri.jpeg',
                        title: 'Cara Memesan Tukang Menggunakan Fitur Deteksi',
                        steps: [
                          'Buka aplikasi Teman Tukang dan pilih menu Deteksi.',
                          'Masuk ke halaman deteksi, lalu unggah gambar kerusakan rumahmu.',
                          'Tekan tombol Deteksi untuk memulai analisis kerusakan.',
                          'Aplikasi akan menampilkan hasil analisis kerusakan.',
                          'Dari hasil deteksi, aplikasi menampilkan rekomendasi tukang sesuai faktor kerusakan.',
                          'Klik salah satu tukang untuk melihat profil dan pengalaman mereka.',
                          'Jika sudah yakin, tekan tombol Pesan Sekarang untuk memesan tukang.',
                          'Jika ingin konsultasi dulu, gunakan tombol Chat untuk berkomunikasi dengan tukang.',
                        ],
                        buttonLabel: 'Coba Deteksi Sekarang',
                        action: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DeteksiPage(),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: _panduanDetailCard(
                        image: 'assets/images/panduankanan.jpeg',
                        title: 'Cara Menjadi Tukang Mitra',
                        steps: [
                          'Hubungi tim kami via WhatsApp untuk verifikasi data.',
                          'Setelah dikonfirmasi, akun akan dibuat di aplikasi Mitra Teman Tukang.',
                          'Login menggunakan email atau nomor telepon.',
                          'Lengkapi profil, termasuk skill dan layanan.',
                          'Mulai menerima pesanan dan kelola pekerjaan dari aplikasi.',
                        ],
                        buttonLabel: 'Hubungi via WA',
                        action: () {},
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// ===========================
              /// ARTIKEL PILIHAN
              /// ===========================
              const Center(
                child: Text(
                  "Cara Perawatan & Renovasi Rumah",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 16),

              _artikelCard(
                context,
                image:
                    "https://assets.promediateknologi.id/crop/0x0:0x0/750x500/webp/photo/2023/02/11/969053708.jpeg",
                title: "Cara Mengenali Kerusakan Rumah Sejak Dini",
                desc:
                    "Kenali tanda-tanda awal kerusakan rumah agar tidak berubah menjadi masalah besar.",
                page: const ArtikelKerusakanAwalPage(),
              ),

              _artikelCard(
                context,
                image:
                    "https://assets.promediateknologi.id/crop/0x0:0x0/750x500/webp/photo/2023/02/11/969053708.jpeg",
                title: "Tips Renovasi Rumah Aman & Hemat",
                desc:
                    "Pelajari cara memilih tukang profesional dan merencanakan renovasi yang efisien.",
                page: const ArtikelRenovasiAmanPage(),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFFF9800),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatbotPage()),
            );
          },
          child: Image.network(
            'https://cdn-icons-png.flaticon.com/128/15511/15511514.png',
            width: 28,
            height: 28,
            color: Colors.white,
          ),
        ),

        bottomNavigationBar: const BottomNav(currentIndex: 0),
      ),
    );
  }

  /// ===============================
  /// CARD PANDUAN
  /// ===============================
  static Widget _panduanDetailCard({
    required String image,
    required String title,
    required List<String> steps,
    required String buttonLabel,
    VoidCallback? action,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFFF9800),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ...steps.asMap().entries.map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '${e.key + 1}. ${e.value}',
                  style: const TextStyle(fontSize: 13, height: 1.3),
                ),
              );
            }),

            const SizedBox(height: 14),

            Center(
              child: ElevatedButton(
                onPressed: action,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  buttonLabel,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===============================
  /// CARD ARTIKEL (Horizontal Style)
  /// ===============================
  static Widget _artikelCard(
    BuildContext context, {
    required String image,
    required String title,
    required String desc,
    required Widget page,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            // LEFT IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: Image.network(
                image,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),

            // RIGHT CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      desc,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => page),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9800),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                        ),
                        child: const Text(
                          "Baca Selengkapnya",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
