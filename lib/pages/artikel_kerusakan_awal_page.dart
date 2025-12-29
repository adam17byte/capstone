
import 'package:flutter/material.dart';

class ArtikelKerusakanAwalPage extends StatelessWidget {
  const ArtikelKerusakanAwalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kerusakan Rumah Sejak Dini"),
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
        'assets/images/mengenali_kerusakan.jpg', // ganti sesuai nama asset kamu
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ),

    const SizedBox(height: 20),

          /// ===== TITLE =====
          const Text(
            "Cara Mengenali Kerusakan Rumah Sejak Dini",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          /// ===== PARAGRAPH =====
          const Text(
            "Kerusakan kecil pada rumah sering kali diabaikan karena dianggap tidak berbahaya. Padahal, jika dibiarkan terlalu lama, kerusakan tersebut dapat berkembang menjadi masalah serius seperti kebocoran parah, retakan struktural, hingga membahayakan keselamatan penghuni rumah.",
            style: TextStyle(fontSize: 15, height: 1.6),
          ),

          const SizedBox(height: 20),

          /// ===== SUBTITLE =====
          const Text(
            "Tanda-tanda Kerusakan yang Perlu Diwaspadai",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          _kerusakanItem(
            icon: Icons.water_drop,
            title: "Dinding atau Atap Bocor",
            desc:
                "Munculnya noda air atau rembesan pada dinding dan plafon bisa menjadi tanda kebocoran serius.",
          ),

          _kerusakanItem(
            icon: Icons.crop_square,
            title: "Retakan pada Dinding",
            desc:
                "Retakan kecil yang terus melebar bisa menjadi indikasi masalah struktural bangunan.",
          ),

          _kerusakanItem(
            icon: Icons.foundation,
            title: "Lantai atau Pondasi Tidak Rata",
            desc:
                "Lantai yang terasa miring atau turun dapat menandakan kerusakan pada pondasi.",
          ),

          _kerusakanItem(
            icon: Icons.warning,
            title: "Pintu dan Jendela Sulit Ditutup",
            desc:
                "Perubahan posisi kusen bisa menjadi tanda pergeseran struktur bangunan.",
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// ===== ITEM KERUSAKAN =====
  static Widget _kerusakanItem({
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
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 6),
                  Text(desc,
                      style:
                          const TextStyle(fontSize: 13, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}