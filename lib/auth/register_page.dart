import 'package:flutter/material.dart';
import '../services/api.dart';
import 'login_page.dart';
import '../services/logger.dart';

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
  bool isPasswordVisible = false;

  // Validation states
  String? namaError;
  String? emailError;
  String? passwordError;

  @override
  void initState() {
    super.initState();
    _setupValidationListeners();
  }

  void _setupValidationListeners() {
    namaController.addListener(() {
      setState(() {
        namaError = namaController.text.isEmpty ? 'Nama tidak boleh kosong' : null;
      });
    });

    emailController.addListener(() {
      setState(() {
        if (emailController.text.isEmpty) {
          emailError = 'Email tidak boleh kosong';
        } else if (!emailController.text.contains('@')) {
          emailError = 'Format email tidak valid';
        } else {
          emailError = null;
        }
      });
    });

    passwordController.addListener(() {
      setState(() {
        if (passwordController.text.isEmpty) {
          passwordError = 'Password tidak boleh kosong';
        } else {
          final strength = _checkPasswordStrength(passwordController.text);
          passwordError = strength['score'] < 3 ? strength['message'] : null;
        }
      });
    });
  }

  Future<void> doRegister() async {
    // STEP 1: VALIDASI LOKAL
    if (namaController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showError('❌ Semua field harus diisi');
      return;
    }

    if (!emailController.text.contains('@')) {
      _showError('❌ Format email tidak valid');
      return;
    }

    // Password strength validation
    final passwordStrength = _checkPasswordStrength(passwordController.text);
    if (passwordStrength['score'] < 3) {
      _showError('❌ ${passwordStrength['message']}');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final result = await Api.register(
        nama: namaController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      if (result['status'] == 'success') {
        Logger.auth('Register', 'Registration successful for ${emailController.text}', true);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Registrasi berhasil! Silakan login.'),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        Logger.auth('Register', 'Registration failed for ${emailController.text}: ${result['message']}', false);
        // TAMPILKAN ERROR DARI SERVER
        _showError(
          '❌ ${result['message'] ?? 'Gagal mendaftar'} (Status: ${result['status']})',
        );
      }
    } on Exception catch (e) {
      Logger.error('Registration exception', e);
      _showError('❌ Koneksi gagal: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showError(String message) {
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

  Map<String, dynamic> _checkPasswordStrength(String password) {
    int score = 0;
    String message = '';

    if (password.length < 8) {
      message = 'Password minimal 8 karakter';
      return {'score': score, 'message': message};
    }

    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    if (score < 3) {
      message = 'Password harus mengandung huruf besar, kecil, angka, dan simbol';
    } else if (score == 3) {
      message = 'Password cukup kuat';
    } else {
      message = 'Password sangat kuat';
    }

    return {'score': score, 'message': message};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Daftar'),
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
              'Daftar Akun Baru',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9800),
              ),
            ),
            const SizedBox(height: 30),

            _buildTextField(
              namaController,
              'Nama Lengkap',
              Icons.person_outline,
              null,
              false,
              null,
              null,
              namaError,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              emailController,
              'Email',
              Icons.email_outlined,
              TextInputType.emailAddress,
              false,
              null,
              null,
              emailError,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              passwordController,
              'Password',
              Icons.lock_outline,
              null,
              true,
              isPasswordVisible,
              () => setState(() => isPasswordVisible = !isPasswordVisible),
              passwordError,
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
                        'Daftar',
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
    bool? isPasswordVisible,
    VoidCallback? onToggleVisibility,
    String? errorText,
  ]) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText && !(isPasswordVisible ?? false),
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFFFF9800)),
      suffixIcon: obscureText
          ? IconButton(
              icon: Icon(
                isPasswordVisible ?? false ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFFFF9800),
              ),
              onPressed: onToggleVisibility,
            )
          : null,
      errorText: errorText,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}