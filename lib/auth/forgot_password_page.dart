import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String message = '';

  Future<void> resetPassword() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');

    if (emailController.text != savedEmail) {
      setState(() => message = 'Email tidak ditemukan!');
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      setState(() => message = 'Kata sandi tidak sama!');
      return;
    }

    await prefs.setString('password', newPasswordController.text);

    setState(() => message = 'Kata sandi berhasil diubah!');
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9800),
        elevation: 1,
        title: const Text(
          'Lupa Kata Sandi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text(
              'Atur Ulang Kata Sandi',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Masukkan email yang terdaftar dan buat kata sandi baru.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            _buildTextField('Email', emailController, icon: Icons.email_outlined),
            _buildTextField('Kata Sandi Baru', newPasswordController,
                icon: Icons.lock_outline, obscure: true),
            _buildTextField('Konfirmasi Kata Sandi', confirmPasswordController,
                icon: Icons.lock_outline, obscure: true),

            const SizedBox(height: 16),

            if (message.isNotEmpty)
              Center(
                child: Text(
                  message,
                  style: TextStyle(
                    color: message.contains('berhasil') ? Colors.green : Colors.red,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan Kata Sandi Baru',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {IconData? icon, bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFFFF9800)),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}