import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'rekomendasi_page.dart';

class HasilDeteksiPage extends StatelessWidget {
  final io.File? imageFile;
  final Uint8List? webImage;

  const HasilDeteksiPage({
    super.key,
    this.imageFile,
    this.webImage,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = kIsWeb
        ? Image.memory(webImage!, fit: BoxFit.cover, height: 220, width: double.infinity)
        : Image.file(imageFile!, fit: BoxFit.cover, height: 220, width: double.infinity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Deteksi'),
        backgroundColor: const Color(0xFFFF9800),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageWidget,
            ),
            const SizedBox(height: 16),
            const Text(
              'Hasil Deteksi Kerusakan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Analisis faktor kerusakan:',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '• Retak dinding bagian bawah\n• Struktur terpapar air',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RekomendasiPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Rekomendasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}
