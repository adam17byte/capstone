import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/login_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const TemanTukangApp());
}

class TemanTukangApp extends StatelessWidget {
  const TemanTukangApp({super.key});

  // CACHE FUTURE agar tidak rebuild berkali-kali (PERFORMANCE FIX)
  static final Future<bool> _loginFuture = _checkLoginStatus();

  static Future<bool> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isLoggedIn') ?? false;
    } catch (e) {
      // Jika error, tetap tampilkan login page
      debugPrint('Login check error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Teman Tukang',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF9800),
        // Gunakan colorScheme untuk Flutter 3.0+ (BEST PRACTICE)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF9800),
          primary: const Color(0xFFFF9800),
        ),
      ),
      home: FutureBuilder<bool>(
        future: _loginFuture, // Tanpa kurung, karena sudah di-cache
        builder: (context, snapshot) {
          // 1. LOADING STATE
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // 2. ERROR HANDLING (INI YANG PENTING!)
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text('Terjadi kesalahan', style: TextStyle(fontSize: 18)),
                    Text('${snapshot.error}', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => runApp(const TemanTukangApp()), // Restart app
                      child: const Text('Muat Ulang'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. SUCCESS - Navigate ke page yang tepat
          return snapshot.data == true ? const HomePage() : const LoginPage();
        },
      ),
    );
  }
}
