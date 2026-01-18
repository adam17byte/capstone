import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/bottom_nav.dart';
import '../auth/login_page.dart';
import 'edit_profil_page.dart'; // Tambahkan import ini

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String username = '';
  String email = '';
  String phone = '';
  String address = '';
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Pengguna';
      email = prefs.getString('email') ?? 'user@mail.com';
      phone = prefs.getString('phone') ?? '-';
      address = prefs.getString('address') ?? '-';
      imagePath = prefs.getString('imagePath');
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();

    // Clear semua data login
    await prefs.remove('isLoggedIn');
    await prefs.remove('userId');
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('role');
    await prefs.remove('jwt');
    await prefs.remove('imagePath');

    // Sign out dari Google jika sedang login Google
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
    } catch (e) {
      // Ignore error jika tidak ada Google account yang login
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  // 🔹 Pindah ke halaman edit profil
  Future<void> _goToEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfilPage()),
    );
    _loadProfile(); // Refresh data setelah edit
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        backgroundColor: const Color(0xFFFF9800),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _goToEditProfile),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Foto profil dinamis
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              backgroundImage: imagePath != null
                  ? FileImage(File(imagePath!))
                  : null,
              child: imagePath == null
                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 12),

            // Username
            Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),

            // Email
            Text(email),
            const SizedBox(height: 24),

            // Info tambahan
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Nomor Telepon'),
                subtitle: Text(phone),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(email),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Alamat'),
                subtitle: Text(address),
              ),
            ),

            const Spacer(),

            // Tombol Logout
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Keluar'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 4),
    );
  }
}