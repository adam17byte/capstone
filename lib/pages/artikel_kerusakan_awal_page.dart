import 'package:flutter/material.dart';

class ArtikelKerusakanAwalPage extends StatelessWidget {
  const ArtikelKerusakanAwalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kerusakan Rumah Sejak Dini"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFFFF9800),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Cara Mengenali Kerusakan Rumah Sejak Dini",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              "Kerusakan kecil pada rumah sering dianggap sepele, padahal jika dibiarkan dapat menjadi masalah besar seperti retakan parah, kebocoran, hingga kerusakan struktural.",
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
     ),
);
}
}

