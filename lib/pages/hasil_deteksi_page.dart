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

  // ======================
  // ANALISIS FAKTOR (LOWERCASE)
  // ======================
  String _analisisFaktor(String label) {
    final map = {
      "tembok retak":
          "Kerusakan terjadi karena fondasi mengalami penurunan tidak merata, getaran berulang, atau tekanan beban berlebih pada struktur dinding.",
      "plafon bocor":
          "Kerusakan plafon biasanya disebabkan oleh kebocoran atap, rembesan air AC, atau material plafon yang sudah rapuh dan tidak mampu menahan beban.",
      "kramik pecah":
          "Keramik retak atau terangkat dapat terjadi akibat permukaan lantai yang tidak rata, penurunan tanah, atau pemasangan awal yang kurang tepat.",
      "cat ngelupas":
          "Cat mengelupas umumnya dipicu oleh kelembaban tinggi, rembesan air, atau permukaan dinding yang tidak dibersihkan dengan baik sebelum pengecatan.",
      "kayu kusen lapuk":
          "Kusen kayu dapat lapuk karena paparan air, kelembaban tinggi, atau serangan jamur dan rayap, sehingga kayu kehilangan kekuatan strukturalnya.",
      "dinding berjamur":
          "Dinding berjamur terjadi akibat kelembaban berlebih, ventilasi yang buruk, atau rembesan air yang terus-menerus.",
    };

    return map[label.toLowerCase()] ??
        "Kerusakan terdeteksi pada bangunan dan memerlukan pemeriksaan lebih lanjut.";
  }

  // ======================
  // MAP KE LABEL BACKEND (WAJIB)
  // ======================
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
              child: Column(
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
              ),
            ),
          ),
          _rekomendasiButton(context),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }

  Widget _infoBox(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(height: 6),
          Text(value, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _analisisBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Text(text, style: const TextStyle(fontSize: 14, height: 1.6), textAlign: TextAlign.justify),
    );
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
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
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
