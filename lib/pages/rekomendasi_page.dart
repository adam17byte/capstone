import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api.dart';
import '../models/tukang.dart';
import 'form_pesanan_page.dart';
import 'profil_tukang_page.dart';

class RekomendasiPage extends StatefulWidget {
  final String jenisKerusakan;

  const RekomendasiPage({
    super.key,
    required this.jenisKerusakan,
  });

  @override
  State<RekomendasiPage> createState() => _RekomendasiPageState();
}

class _RekomendasiPageState extends State<RekomendasiPage> {
  bool isLoading = true;
  String errorMessage = "";
  List<Tukang> tukangList = [];

  @override
  void initState() {
    super.initState();
    fetchRekomendasi();
  }

  Future<void> fetchRekomendasi() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt');

      if (token == null || token.isEmpty) {
        setState(() {
          errorMessage = "Sesi login berakhir. Silakan login ulang.";
          isLoading = false;
        });
        return;
      }

      final result = await Api.getRekomendasi(
        jenisKerusakan: widget.jenisKerusakan,
        token: token,
      );

      if (!mounted) return;

      if (result["status"] == "success" && result["data"] is List) {
        final List data = result["data"];

        final list = data.map((e) => Tukang.fromJson(e)).toList();

        // SORTING: RATING TERTINGGI DI ATAS
        list.sort((a, b) => b.rating.compareTo(a.rating));

        setState(() {
          tukangList = list;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              result["message"] ?? "Gagal memuat rekomendasi tukang";
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = "Terjadi kesalahan jaringan";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rekomendasi Tukang"),
        backgroundColor: Colors.orange,
      ),
      body: RefreshIndicator(
        onRefresh: fetchRekomendasi,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 100),
          Center(
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    if (tukangList.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 100),
          Center(
            child: Text("Tidak ada tukang yang cocok"),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tukangList.length,
      itemBuilder: (context, index) {
        final tukang = tukangList[index];

        return _tukangCard(tukang);
      },
    );
  }

  Widget _tukangCard(Tukang tukang) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilTukangPage(idTukang: tukang.id),
                ),
              );
            },
            child: CircleAvatar(
              radius: 30,
                backgroundImage: tukang.foto.isNotEmpty && tukang.foto.startsWith('http')
                  ? NetworkImage(tukang.foto)
                  : const AssetImage('assets/images/logo_temantukang.png') as ImageProvider,
                onBackgroundImageError: (_, __) {},
                child: tukang.foto.isEmpty
                  ? const Icon(Icons.person, size: 30)
                  : null,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tukang.nama,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tukang.keahlian,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      tukang.rating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FormPesananPage(
                            namaTukang: tukang.nama,
                            tukangId: tukang.id,
                            jenisKerusakan: widget.jenisKerusakan,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Pesan Sekarang",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}