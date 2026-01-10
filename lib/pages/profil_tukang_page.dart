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
  String errorMessage = "";
  Map<String, dynamic>? tukang;
  List<dynamic> ulasan = [];

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
        errorMessage = "Terjadi kesalahan: $e";
        isLoading = false;
      });
    }
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
        body: Center(
          child: Text(
            errorMessage,
            textAlign: TextAlign.center,
          ),
        ),
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
            // HEADER PROFIL
            Center(
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
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star,
                          color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        tukang!["rating"].toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "(${tukang!["jumlah_ulasan"]} ulasan)",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // KEAHLIAN
            const Text(
              "Keahlian",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              tukang!["keahlian"],
              style: const TextStyle(color: Colors.black87),
            ),

            const SizedBox(height: 16),

            // PENGALAMAN
            const Text(
              "Pengalaman",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              tukang!["pengalaman"] ?? "-",
              style: const TextStyle(color: Colors.black87),
            ),

            const SizedBox(height: 24),

            // ULASAN
            const Text(
              "Ulasan Customer",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            if (ulasan.isEmpty)
              const Text(
                "Belum ada ulasan",
                style: TextStyle(color: Colors.grey),
              ),

            ...ulasan.map((u) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(u["rating"].toString()),
                        const Spacer(),
                        Text(
                          u["sentiment"] ?? "",
                          style: TextStyle(
                            color: u["sentiment"] == "positif"
                                ? Colors.green
                                : Colors.red,
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
            }).toList(),
          ],
        ),
      ),
    );
  }
}
