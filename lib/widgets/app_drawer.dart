// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../pages/home_page.dart';
// import '../pages/riwayat_page.dart';
// import '../pages/deteksi_page.dart';
// import '../pages/chat_page.dart';
// import '../pages/profil_page.dart';

// class AppDrawer extends StatefulWidget {
//   const AppDrawer({super.key});

//   @override
//   State<AppDrawer> createState() => _AppDrawerState();
// }

// class _AppDrawerState extends State<AppDrawer> {
//   String? name;
//   String? imagePath;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       name = prefs.getString('username') ?? 'Pengguna';
//       imagePath = prefs.getString('imagePath');
//     });
//   }

//   Widget _tile(String title, IconData icon, Widget page) {
//     return ListTile(
//       leading: Icon(icon, color: const Color(0xFFFF9800)),
//       title: Text(title),
//       onTap: () {
//         Navigator.pop(context);
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//           child: Column(
//             children: [
//               CircleAvatar(
//                 radius: 36,
//                 backgroundColor: Colors.grey.shade300,
//                 backgroundImage: imagePath != null ? FileImage(File(imagePath!)) : null,
//                 child: imagePath == null
//                     ? const Icon(Icons.person, color: Colors.white, size: 40)
//                     : null,
//               ),
//               const SizedBox(height: 12),
//               Text(name ?? 'Pengguna',
//                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//               const SizedBox(height: 24),
//               _tile('Beranda', Icons.home, const HomePage()),
//               _tile('Riwayat Pesanan', Icons.history, const RiwayatPage()),
//               _tile('Deteksi', Icons.camera_alt, const DeteksiPage()),
//               _tile('Chat Tukang', Icons.chat, const ChatPage()),
//               _tile('Profil', Icons.person, const ProfilPage()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }