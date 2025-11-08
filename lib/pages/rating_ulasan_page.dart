import 'package:flutter/material.dart';

class RatingUlasanPage extends StatefulWidget {
  final String tukangName;

  const RatingUlasanPage({super.key, required this.tukangName});

  @override
  State<RatingUlasanPage> createState() => _RatingUlasanPageState();
}

class _RatingUlasanPageState extends State<RatingUlasanPage> {
  double rating = 0;
  final ulasanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rating & Ulasan'),
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        backgroundColor: const Color(0xFFFF9800),
        iconTheme: const IconThemeData(color: Colors.white),

      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tukang: ${widget.tukangName}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Beri rating untuk tukang ini:',
                style: TextStyle(fontSize: 14)),
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
                    color: starIndex <= rating ? const Color(0xFFFFC107) : Colors.grey.shade400,
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
                onPressed: () {
                  if (rating == 0 || ulasanController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mohon isi rating dan ulasan terlebih dahulu.'),
                      ),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Terima kasih! Rating ${rating.toStringAsFixed(1)} dikirim untuk ${widget.tukangName}.'),
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Kirim Ulasan',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}