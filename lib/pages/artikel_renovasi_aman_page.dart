import 'package:flutter/material.dart';

class ArtikelRenovasiAmanPage extends StatelessWidget {
  const ArtikelRenovasiAmanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Renovasi Rumah Aman & Hemat"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: const Color(0xFFFF9800),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Tips Renovasi Rumah Aman & Hemat",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              "Merencanakan renovasi rumah seringkali memakan biaya besar. Dengan memilih tukang profesional dan perencanaan yang tepat, kamu bisa menghemat biaya dan menghindari kerusakan tambahan.",
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
     ),
);
}
}
