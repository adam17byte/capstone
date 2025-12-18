import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'rekomendasi_page.dart';

class HasilDeteksiPage extends StatelessWidget {
  final io.File? imageFile;
  final Uint8List? webImage;
  final String hasilLabel;
  final double confidence; // tidak ditampilkan

  const HasilDeteksiPage({
    super.key,
    this.imageFile,
    this.webImage,
    required this.hasilLabel,
    required this.confidence,
  });

  String _analisisFaktor(String label) {
    final Map<String, String> analisisFaktor = {
      "tembok retak":
          "Kerusakan terjadi karena fondasi mengalami penurunan tidak merata, getaran berulang, atau tekanan beban berlebih pada struktur dinding.",
      "plafon bocor":
          "Kerusakan plafon biasanya disebabkan oleh kebocoran atap, rembesan air AC, atau material plafon yang sudah rapuh dan tidak mampu menahan beban.",
      "kramik pecah":
          "Keramik retak atau terangkat dapat terjadi akibat permukaan lantai yang tidak rata, penurunan tanah, atau pemasangan awal yang kurang tepat.",
      "cat ngelupas":
          "Cat mengelupas umumnya dipicu oleh kelembaban tinggi, rembesan air, atau permukaan dinding yang tidak dibersihkan dengan baik sebelum pengecatan.",
      "Kayu Kusen Lapuk":
          "Kusen kayu dapat lapuk karena paparan air, kelembaban tinggi, atau serangan jamur dan rayap, sehingga kayu kehilangan kekuatan strukturalnya.",
      "Dinding Berjamur":
          "Dinding berjamur terjadi akibat kelembaban berlebih, ventilasi yang buruk, atau rembesan air yang terus-menerus, sehingga jamur berkembang di permukaan dinding.",
    };

    return analisisFaktor[label] ??
        "Kerusakan terdeteksi pada bangunan dan memerlukan pemeriksaan lebih lanjut.";
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = kIsWeb
        ? Image.memory(
            webImage!,
            fit: BoxFit.cover,
            height: 300,
            width: double.infinity,
          )
        : Image.file(
            imageFile!,
            fit: BoxFit.cover,
            height: 300,
            width: double.infinity,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Deteksi'),
        backgroundColor: const Color(0xFFFF9800),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageWidget,
                  ),

                  const SizedBox(height: 20),

                  // BOX JENIS KERUSAKAN
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Jenis Kerusakan',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          hasilLabel,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // BOX ANALISIS FAKTOR
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Analisis Faktor Kerusakan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _analisisFaktor(hasilLabel),
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // BUTTON DI BAWAH
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RekomendasiPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Lihat Rekomendasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}