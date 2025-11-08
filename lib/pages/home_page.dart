import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'deteksi_page.dart';
import 'chatbot_page.dart';
import 'notifikasi_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9800),
        elevation: 0,

leading: Padding(
  padding: const EdgeInsets.only(left: 12),
  child: Container(
    width: 42,
    height: 42,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.orange.withOpacity(0.3),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ClipOval(
      child: Image.asset(
        'assets/images/logotukang.jpeg',
        fit: BoxFit.cover,
      ),
    ),
  ),
),

        title: const Text(
          'Teman Tukang',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),

        // 🔔 Notifikasi di kanan atas
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

      // 🏡 Isi Halaman
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔶 Banner utama
            Stack(
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
                  color: Colors.black.withOpacity(0.45),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Selamat Datang!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          'Temukan layanan tukang profesional dan terpercaya '
                          'untuk semua kebutuhan renovasi dan perbaikan rumahmu.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DeteksiPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9800),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 13,
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Temukan Tukang',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 🔸 Layanan Teman Tukang
            const Text(
              'Layanan Teman Tukang',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _layananCard(icon: Icons.build, title: 'Perbaikan Rumah'),
                  _layananCard(
                    icon: Icons.plumbing,
                    title: 'Pemeliharaan Rumah',
                  ),
                  _layananCard(
                    icon: Icons.house_rounded,
                    title: 'Renovasi & Peningkatan',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Panduan Penggunaan
            const Text(
              'Panduan Penggunaan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _panduanCard(
                    icon: Icons.lightbulb_outline,
                    title: 'Cara Deteksi Kerusakan',
                    desc:
                        'Pelajari langkah-langkah mudah mendeteksi kerusakan bangunan.',
                  ),
                  _panduanCard(
                    icon: Icons.handyman_outlined,
                    title: 'Tips Perawatan Rumah',
                    desc:
                        'Temukan cara merawat rumah agar tetap kuat dan tahan lama.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // 🤖 Tombol Chatbot
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
    );
  }

  // 🔸 Widget Kartu Layanan
  static Widget _layananCard({required IconData icon, required String title}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      shadowColor: Colors.orangeAccent.withOpacity(0.3),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFFFF9800), size: 40),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Widget Kartu Panduan
  static Widget _panduanCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: Colors.orange.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFFFF9800), size: 36),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              desc,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
