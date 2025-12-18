import 'package:flutter/material.dart';
import '../services/api.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMessage = '';
  bool isLoading = false;

  Future<void> doRegister() async {
    // STEP 1: VALIDASI LOKAL
    if (namaController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showError("❌ Semua field harus diisi");
      return;
    }

    if (!emailController.text.contains('@')) {
      _showError("❌ Format email tidak valid");
      return;
    }

    print('🚀 MENGIRIM REGISTER...'); // DEBUG PRINT
    print('Nama: ${namaController.text}');
    print('Email: ${emailController.text}');

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      var result = await Api.register(
        namaController.text,
        emailController.text,
        passwordController.text,
      );

      print('✅ RESPONSE DITERIMA: $result'); // DEBUG PRINT

      if (result['status'] == 'success') {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Registrasi berhasil! Silakan login."),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        // TAMPILKAN ERROR DARI SERVER
        _showError(
          "❌ ${result['message'] ?? 'Gagal mendaftar'} (Status: ${result['status']})",
        );
      }
    } catch (e) {
      print('🔥 ERROR TERJEBAK: $e'); // DEBUG PRINT
      _showError("❌ Koneksi gagal: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showError(String message) {
    print('⚠ ERROR DITAMPILKAN: $message'); // DEBUG PRINT
    setState(() {
      errorMessage = message;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5), // PERPANJANG DURASI
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Daftar"),
        backgroundColor: const Color(0xFFFF9800),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.app_registration,
              size: 90,
              color: Color(0xFFFF9800),
            ),
            const SizedBox(height: 16),
            const Text(
              "Daftar Akun Baru",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9800),
              ),
            ),
            const SizedBox(height: 30),

            _buildTextField(
              namaController,
              "Nama Lengkap",
              Icons.person_outline,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              emailController,
              "Email",
              Icons.email_outlined,
              TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              passwordController,
              "Password",
              Icons.lock_outline,
              null,
              true,
            ),

            // TAMPILKAN ERROR MESSAGE DI UI
            if (errorMessage.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : doRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Daftar",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, [
    TextInputType? keyboardType,
    bool obscureText = false,
  ]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
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
    );
  }
}
