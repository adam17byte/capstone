import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/constants.dart';
import 'rekomendasi_page.dart';

class HasilDeteksiPage extends StatelessWidget {
  final io.File? imageFile;
  final Uint8List? webImage;
  final String hasilLabel;
  final double confidence;

  const HasilDeteksiPage({
    super.key,
    this.imageFile,
    this.webImage,
    required this.hasilLabel,
    required this.confidence,
  });

  // =====================================================
  // CONFIDENCE THRESHOLD (PENCEGAHAN GAMBAR NGASAL)
  // =====================================================
  bool isValidDetection(double confidence) {
    return confidence >= 0.3; // 30%
  }

  // =====================================================
  // ANALISIS FAKTOR (UI ONLY)
  // =====================================================
  String _analisisFaktor(String label) {
    final map = {
      "tembok retak":
          "Kerusakan terjadi karena penurunan fondasi, getaran berulang, atau tekanan beban berlebih pada struktur dinding.",
      "plafon bocor":
          "Kerusakan plafon biasanya disebabkan oleh kebocoran atap, rembesan air, atau material plafon yang sudah rapuh.",
      "kramik pecah":
          "Keramik rusak dapat terjadi akibat permukaan lantai tidak rata atau pemasangan yang kurang tepat.",
      "cat ngelupas":
          "Cat mengelupas dipicu oleh kelembaban tinggi atau permukaan dinding yang tidak siap saat pengecatan.",
      "kayu kusen lapuk":
          "Kusen kayu lapuk akibat paparan air, jamur, atau serangan rayap.",
      "dinding berjamur":
          "Jamur muncul akibat ventilasi buruk dan kelembaban berlebih.",
    };

    return map[label.toLowerCase()] ??
        "Kerusakan terdeteksi dan memerlukan pemeriksaan lebih lanjut.";
  }

  // =====================================================
  // MAPPING KE LABEL BACKEND
  // =====================================================
  String mapToBackendLabel(String label) {
    final map = {
      "tembok retak": "Retak Dinding",
      "plafon bocor": "Plafon Rusak",
      "kramik pecah": "Keramik Rusak",
      "cat ngelupas": "Cat Mengelupas",
      "kayu kusen lapuk": "Kayu Kusen Lapuk",
      "dinding berjamur": "Dinding Berjamur",
    };

    return map[label.toLowerCase()] ?? "Retak Dinding";
  }

  @override
  Widget build(BuildContext context) {
    final bool valid = isValidDetection(confidence);

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
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: valid
                  ? Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: imageWidget,
                        ),
                        const SizedBox(height: 20),
                        _infoBox("Jenis Kerusakan", hasilLabel),
                        const SizedBox(height: 16),
                        _analisisBox(_analisisFaktor(hasilLabel)),
                      ],
                    )
                  : Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: imageWidget,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: _boxDecoration(),
                          child: const Text(
                            "Gambar tidak dapat dikenali sebagai kerusakan bangunan.\n\n"
                            "Pastikan foto menampilkan bagian rumah yang rusak, "
                            "pencahayaan cukup, dan fokus pada area kerusakan.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, height: 1.6),
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          // TOMBOL REKOMENDASI HANYA MUNCUL JIKA VALID
          if (valid) _rekomendasiButton(context),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }

  // =====================================================
  // UI COMPONENTS
  // =====================================================
  Widget _infoBox(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _analisisBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, height: 1.6),
        textAlign: TextAlign.justify,
      ),
    );
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      );

  Widget _rekomendasiButton(BuildContext context) {
    final backendLabel = mapToBackendLabel(hasilLabel);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RekomendasiPage(
                    jenisKerusakan: backendLabel,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
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
    );
  }
}