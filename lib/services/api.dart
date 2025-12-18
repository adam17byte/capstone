import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  // Gunakan NGROK sebagai base URL
  static String baseUrl = "https://witted-gentler-jeanett.ngrok-free.dev/teman_tukang_api";

  static Future<Map<String, dynamic>> register(String nama, String email, String password) async {
    try {
      print('📡 POST: $baseUrl/register.php');
      print('📦 Body: nama=$nama, email=$email');

      final response = await http.post(
        Uri.parse("$baseUrl/register.php"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "nama": nama,
          "email": email,
          "password": password,
        },
      ).timeout(const Duration(seconds: 10));

      print('📥 HTTP Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {"status": "error", "message": "HTTP Error: ${response.statusCode}"};
    } catch (e) {
      print('🔥 ERROR: ${e.toString()}');
      return {"status": "error", "message": "Koneksi gagal: ${e.toString()}"};
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login.php"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "email": email,
          "password": password,
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {"status": "error", "message": "HTTP Error: ${response.statusCode}"};
    } catch (e) {
      return {"status": "error", "message": "Koneksi gagal: ${e.toString()}"};
}
}
}
