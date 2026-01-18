import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/api.dart';
import '../pages/home_page.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
// import '../services/logger.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '152566724840-itl7926ncrk5pi4lhqtmqtpoaioe5cgr.apps.googleusercontent.com',
  );

  String error = '';
  bool isLoading = false;
  bool isPasswordVisible = false;

  // Rate limiting
  int _failedAttempts = 0;
  DateTime? _lastFailedAttempt;
  bool _isRateLimited = false;

  // ======================
  // LOGIN EMAIL / PASSWORD
  // ======================
  Future<void> doLogin() async {
    if (_isRateLimited) {
      final remainingTime = _getRemainingLockoutTime();
      if (remainingTime > 0) {
        setState(() {
          error =
              'Terlalu banyak percobaan login gagal. Coba lagi dalam $remainingTime detik.';
        });
        return;
      } else {
        _resetRateLimit();
      }
    }

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() => error = 'Email dan password wajib diisi');
      return;
    }

    setState(() {
      isLoading = true;
      error = '';
    });

    final result = await Api.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (result['status'] != 'success') {
      _handleLoginFailure();
      setState(() {
        error = result['message'] ?? 'Login gagal';
        isLoading = false;
      });
      return;
    }

    final data = result['data'];
    if (data == null || data is! Map) {
      setState(() {
        error = 'Response server tidak valid';
        isLoading = false;
      });
      return;
    }

    final user = data['user'];
    final token = data['access_token'];

    if (user == null || token == null) {
      setState(() {
        error = 'Data login tidak lengkap';
        isLoading = false;
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setInt('userId', user['id_users']);
    await prefs.setString('username', user['username'] ?? '');
    await prefs.setString('email', user['email'] ?? '');
    await prefs.setString('role', user['role']);
    await prefs.setString('jwt', token);

    if (!mounted) return;

    // setState(() => isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  void _handleLoginFailure() {
    _failedAttempts++;
    _lastFailedAttempt = DateTime.now();

    if (_failedAttempts >= 5) {
      _isRateLimited = true;
    }
  }

  void _resetRateLimit() {
    _failedAttempts = 0;
    _lastFailedAttempt = null;
    _isRateLimited = false;
  }

  int _getRemainingLockoutTime() {
    if (_lastFailedAttempt == null) return 0;

    final lockoutDuration = Duration(minutes: _failedAttempts >= 5 ? 5 : 0);
    final lockoutEnd = _lastFailedAttempt!.add(lockoutDuration);
    final remaining = lockoutEnd.difference(DateTime.now());

    return remaining.inSeconds > 0 ? remaining.inSeconds : 0;
  }

  // ======================
  // LOGIN GOOGLE
  // ======================
  Future<void> doGoogleLogin() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        setState(() => isLoading = false);
        return;
      }

      final auth = await account.authentication;
      final idToken = auth.idToken;

      if (idToken == null) {
        throw Exception('ID Token kosong');
      }

      final result = await Api.loginGoogle(idToken: idToken);

      if (result['status'] != 'success') {
        setState(() {
          error = result['message'] ?? 'Login Google gagal';
          isLoading = false;
        });
        return;
      }

      final data = result['data'];
      if (data == null || data is! Map) {
        setState(() {
          error = 'Response server tidak valid';
          isLoading = false;
        });
        return;
      }

      final user = data['user'];
      final token = data['access_token'];

      if (user == null || token == null) {
        setState(() {
          error = 'Data login Google tidak lengkap';
          isLoading = false;
        });
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setInt('userId', user['id_users']);
      await prefs.setString('username', user['username']);
      await prefs.setString('email', user['email']);
      await prefs.setString('role', user['role']);
      await prefs.setString('jwt', token);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      setState(() => error = e.toString());
    }

    setState(() => isLoading = false);
  }

  // ======================
  // UI
  // ======================
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          height: screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_temantukang.png',
                width: 180,
                height: 180,
              ),
              const SizedBox(height: 24),

              TextField(
                controller: emailController,
                decoration: input('Email', Icons.email_outlined),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: input(
                  'Password',
                  Icons.lock_outline,
                  isPassword: true,
                  isPasswordVisible: isPasswordVisible,
                  onToggleVisibility: () {
                    setState(() => isPasswordVisible = !isPasswordVisible);
                  },
                ),
              ),

              if (error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(error, style: const TextStyle(color: Colors.red)),
                ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : doLogin,
                  style: orangeButton(),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : doGoogleLogin,
                  icon: Image.asset(
                    'assets/images/google.png',
                    width: 30,
                    height: 30,
                  ),
                  label: const Text(
                    'Login dengan Google',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFFF9800)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                ),
                child: const Text(
                  'Belum punya akun? Daftar',
                  style: TextStyle(
                    color: Color(0xFFFF9800),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                ),
                child: const Text(
                  'Lupa Password?',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ======================
  // UI HELPER
  // ======================
  InputDecoration input(
    String label,
    IconData icon, {
    bool isPassword = false,
    bool? isPasswordVisible,
    VoidCallback? onToggleVisibility,
  }) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: const Color(0xFFFF9800)),
    suffixIcon: isPassword
        ? IconButton(
            icon: Icon(
              isPasswordVisible ?? false
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: const Color(0xFFFF9800),
            ),
            onPressed: onToggleVisibility,
          )
        : null,
    filled: true,
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );

  ButtonStyle orangeButton() => ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFFF9800),
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}