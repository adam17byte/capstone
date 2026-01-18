import 'package:flutter/material.dart';
import '../services/api.dart'; // pastikan ada file api.dart dan fungsi updateRatingUlasan

class RetingUlasanPage extends StatefulWidget {
  final int orderId;
  final int tukangId;
  final String namaTukang;

  const RetingUlasanPage({
    super.key,
    required this.orderId,
    required this.tukangId,
    required this.namaTukang,
  });

  @override
  State<RetingUlasanPage> createState() => _RetingUlasanPageState();
}

class _RetingUlasanPageState extends State<RetingUlasanPage> {
  double rating = 0;
  final ulasanController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    ulasanController.dispose();
    super.dispose();
  }

  Future<void> _kirimRatingUlasan() async {
    if (rating == 0 || ulasanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi rating dan ulasan terlebih dahulu.'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });
    final result = await Api.kirimReview(
      pesananId: widget.orderId,
      tukangId: widget.tukangId,
      reviewText: ulasanController.text,
      rating: rating.toInt(),
    );

    setState(() {
      isLoading = false;
    });

    if (result['status'] == 'success') {
      // Sukses update, kembali ke halaman riwayat & trigger refresh
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terima kasih! Rating & ulasan dikirim.')),
      );
      Navigator.pop(context, true); // true supaya riwayat refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal mengirim rating/ulasan: ${result['message'] ?? ''}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating & Ulasan'),
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        backgroundColor: const Color(0xFFFF9800),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tukang: ${widget.namaTukang}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Beri rating untuk tukang ini:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return IconButton(
                  onPressed: () {
                    setState(() => rating = starIndex.toDouble());
                  },
                  icon: Icon(
                    Icons.star,
                    size: 36,
                    color: starIndex <= rating
                        ? const Color(0xFFFFC107)
                        : Colors.grey.shade400,
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            const Text('Tulis ulasan kamu:', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: ulasanController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Ceritakan pengalamanmu dengan tukang ini...',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _kirimRatingUlasan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'Kirim Ulasan',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}