import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'chatbot_page.dart';
import 'notifikasi_page.dart';
import 'artikel_kerusakan_awal_page.dart';
import 'artikel_renovasi_aman_page.dart';
import 'panduan_deteksi_page.dart';
import 'panduan_mitra_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _panduanController = PageController();
  int _currentPanduan = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Transform.scale(
              scale: 2.5,
              child: Image.asset('assets/images/logo_temantukang.png'),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_active_outlined),
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
            children: [
              /// =========================== BANNER  ===========================
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

              /// ================= PANDUAN =================
              const Text(
                'Panduan Penggunaan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              /// ===== PAGEVIEW PANDUAN =====
              SizedBox(
                height: 320,
                child: PageView(
                  controller: _panduanController,
                  onPageChanged: (index) {
                    setState(() => _currentPanduan = index);
                  },
                  children: [
                    _panduanCard(
                      context: context,
                      image: 'assets/images/panduankiri.jpeg',
                      title: 'Memesan Tukang dengan Deteksi',
                      desc:
                          'Gunakan fitur deteksi untuk mengetahui jenis kerusakan bangunan dan mendapatkan rekomendasi tukang secara otomatis.',
                      page: const PanduanDeteksiPage(),
                    ),
                    _panduanCard(
                      context: context,
                      image: 'assets/images/panduankanan.jpeg',
                      title: 'Menjadi Tukang Mitra',
                      desc:
                          'Daftarkan diri Anda sebagai mitra Teman Tukang dan mulai menerima pesanan sesuai keahlian.',
                      page: const PanduanMitraPage(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// ===== DOT INDICATOR =====
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  2,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPanduan == index ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPanduan == index
                          ? const Color(0xFFFF9800)
                          : const Color.fromARGB(255, 224, 224, 224),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// ================= ARTIKEL =================
              const Text(
                "Cara Perawatan & Renovasi Rumah",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              _artikelCard(
                context,
                image: 'assets/images/mengenali_kerusakan.jpg',
                title: "Mengenali Kerusakan Rumah",
                desc: "Kenali tanda-tanda awal kerusakan rumah sejak dini.",
                page: const ArtikelKerusakanAwalPage(),
              ),

              _artikelCard(
                context,
                image: 'assets/images/tips_renovasi.jpg',
                title: "Tips Renovasi Aman & Hemat",
                desc: "Tips renovasi rumah agar aman dan sesuai anggaran.",
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
          child: const Icon(Icons.chat, color: Colors.white),
        ),

        bottomNavigationBar: const BottomNav(currentIndex: 0),
      ),
    );
  }

  /// ================= CARD PANDUAN =================
  static Widget _panduanCard({
    required BuildContext context,
    required String image,
    required String title,
    required String desc,
    required Widget page,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 5,
        color: const Color.fromARGB(255, 248, 243, 234), // 👈 background card
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  image,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFFFF9800),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                desc,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13.5, height: 1.4),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => page),
                    );
                  },
                  child: const Text(
                    'Lihat Selengkapnya',
                    style: TextStyle(
                      color: Color(0xFFFF9800),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= CARD ARTIKEL =================
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
        color: const Color.fromARGB(255, 248, 243, 234),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: Image.asset(
                image,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(desc, style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => page),
                          );
                        },
                        child: const Text(
                          'Lihat Selengkapnya',
                          style: TextStyle(
                            color: Color(0xFFFF9800),
                            fontWeight: FontWeight.w600,
                          ),
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
