import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api.dart';

class ProfilTukangPage extends StatefulWidget {
  final int idTukang;

  const ProfilTukangPage({super.key, required this.idTukang});

  @override
  State<ProfilTukangPage> createState() => _ProfilTukangPageState();
}

class _ProfilTukangPageState extends State<ProfilTukangPage> {
  bool isLoading = true;
  bool isLoadingReview = false;
  String errorMessage = "";

  Map<String, dynamic>? tukang;
  List<dynamic> ulasan = [];

  int page = 1;
  final int limit = 5;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    fetchProfilTukang();
  }

  Future<void> fetchProfilTukang() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("jwt");

      if (token == null || token.isEmpty) {
        setState(() {
          errorMessage = "Token tidak ditemukan. Silakan login ulang.";
          isLoading = false;
        });
        return;
      }

      final response = await Api.getTukangProfilePublic(
        idTukang: widget.idTukang,
        token: token,
      );

      if (!mounted) return;

      if (response["status"] == "success") {
        setState(() {
          tukang = response["data"]["tukang"];
          ulasan = response["data"]["ulasan"] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = response["message"] ?? "Gagal memuat profil tukang";
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = "Terjadi kesalahan";
        isLoading = false;
      });
    }
  }

  String _sentimentLabel(String value) {
    if (value == "positif") return "Ulasan Positif";
    if (value == "negatif") return "Ulasan Negatif";
    return "Netral";
  }

  Color _sentimentColor(String value) {
    if (value == "positif") return Colors.green;
    if (value == "negatif") return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profil Tukang"),
          backgroundColor: Colors.orange,
        ),
        body: Center(child: Text(errorMessage)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Profil Tukang"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 24),
            _section("Keahlian", tukang!["keahlian"]),
            _section("Pengalaman", tukang!["pengalaman"] ?? "-"),
            const SizedBox(height: 24),
            const Text(
              "Ulasan Customer",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            if (ulasan.isEmpty)
              const Text("Belum ada ulasan", style: TextStyle(color: Colors.grey)),

            ...ulasan.map(_reviewCard).toList(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundImage: tukang!["foto"] != null &&
                    tukang!["foto"].toString().isNotEmpty
                ? NetworkImage(tukang!["foto"])
                : null,
            child: tukang!["foto"] == null ||
                    tukang!["foto"].toString().isEmpty
                ? const Icon(Icons.person, size: 48)
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            tukang!["nama"],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(tukang!["rating"].toString()),
              const SizedBox(width: 6),
              Text(
                "(${tukang!["jumlah_ulasan"]} ulasan)",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _section(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(content),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _reviewCard(dynamic u) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(u["rating"].toString()),
              const Spacer(),
              Text(
                _sentimentLabel(u["sentiment"]),
                style: TextStyle(
                  color: _sentimentColor(u["sentiment"]),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(u["review_text"]),
        ],
      ),
    );
  }
}
