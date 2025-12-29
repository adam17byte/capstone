import 'package:flutter/material.dart';

class ArtikelRenovasiAmanPage extends StatelessWidget {
  const ArtikelRenovasiAmanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Renovasi Rumah Aman & Hemat"),
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        backgroundColor: const Color(0xFFFF9800),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          /// ===== HEADER IMAGE =====
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/tips_renovasi.jpg', // ganti sesuai nama asset kamu
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 20),

          /// ===== TITLE =====
          const Text(
            "Tips Renovasi Rumah Aman & Hemat",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          /// ===== PARAGRAPH =====
          const Text(
            "Renovasi rumah sering kali membutuhkan biaya yang tidak sedikit. Tanpa perencanaan yang matang, renovasi justru bisa menimbulkan masalah baru seperti pembengkakan anggaran, pekerjaan yang tidak rapi, hingga kerusakan struktural. Oleh karena itu, penting untuk melakukan renovasi secara aman, terencana, dan efisien.",
            style: TextStyle(fontSize: 15, height: 1.6),
          ),

          const SizedBox(height: 20),

          /// ===== SUBTITLE =====
          const Text(
            "Tips Renovasi yang Bisa Kamu Terapkan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          _tipsItem(
            icon: Icons.edit_document,
            title: "Buat Perencanaan yang Jelas",
            desc:
                "Tentukan bagian rumah yang ingin direnovasi, estimasi biaya, dan waktu pengerjaan agar renovasi berjalan terkontrol.",
          ),

          _tipsItem(
            icon: Icons.engineering,
            title: "Gunakan Tukang Profesional",
            desc:
                "Memilih tukang yang berpengalaman dapat mengurangi risiko kesalahan kerja dan menghindari biaya perbaikan ulang.",
          ),

          _tipsItem(
            icon: Icons.shopping_cart,
            title: "Pilih Material Berkualitas",
            desc:
                "Material yang baik memang lebih mahal di awal, tetapi lebih awet dan menghemat biaya jangka panjang.",
          ),

          _tipsItem(
            icon: Icons.attach_money,
            title: "Sesuaikan dengan Anggaran",
            desc:
                "Prioritaskan kebutuhan utama dan hindari renovasi berlebihan agar biaya tetap terkendali.",
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// ===== ITEM TIPS =====
  static Widget _tipsItem({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFFF9800),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(desc, style: const TextStyle(fontSize: 13, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}