import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  // =========================
  // BASE URL
  // =========================
  static const String baseUrl = "https://witted-gentler-jeanett.ngrok-free.dev";

  static const Duration timeoutDuration = Duration(seconds: 15);

  // =========================
  // HEADERS
  // =========================
  static const Map<String, String> _jsonHeaders = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  static Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');

    return {
      ..._jsonHeaders,
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  // =========================
  // RESPONSE HANDLER
  // =========================
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return decoded;
      }

      return {
        "status": "error",
        "message": decoded["message"] ?? "HTTP Error ${response.statusCode}",
      };
    } catch (_) {
      return {"status": "error", "message": "Response bukan JSON"};
    }
  }

  static Map<String, dynamic> _error(String message) {
    return {"status": "error", "message": message};
  }

  // =========================
  // REGISTER
  // =========================
  static Future<Map<String, dynamic>> register({
    required String nama,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/register"),
            headers: _jsonHeaders,
            body: jsonEncode({
              "nama": nama,
              "email": email,
              "password": password,
            }),
          )
          .timeout(timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      return _error("Koneksi gagal: $e");
    }
  }

  // =========================
  // LOGIN
  // =========================
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/login"),
            headers: _jsonHeaders,
            body: jsonEncode({"email": email, "password": password}),
          )
          .timeout(timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      return _error("Koneksi gagal: $e");
    }
  }

  // =========================
  // GOOGLE LOGIN
  // =========================
  static Future<Map<String, dynamic>> loginGoogle({
    required String idToken,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/auth/google"),
            headers: _jsonHeaders,
            body: jsonEncode({"id_token": idToken}),
          )
          .timeout(timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      return _error("Koneksi gagal: $e");
    }
  }

  // =========================
  // REKOMENDASI TUKANG (JWT)
  // =========================
  static Future<Map<String, dynamic>> getRekomendasi({
    required String jenisKerusakan,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/rekomendasi"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"jenis_kerusakan": jenisKerusakan}),
      );

      return _handleResponse(response);
    } catch (e) {
      return {"status": "error", "message": "Request gagal: $e"};
    }
  }

  // =========================
  // KIRIM REVIEW (JWT)
  // =========================
  static Future<Map<String, dynamic>> kirimReview({
    required int tukangId,
    required String reviewText,
    required int rating,
  }) async {
    try {
      final headers = await _authHeaders();

      final response = await http
          .post(
            Uri.parse("$baseUrl/api/review"),
            headers: headers,
            body: jsonEncode({
              "tukang_id": tukangId,
              "review_text": reviewText,
              "rating": rating,
            }),
          )
          .timeout(timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      return _error("Koneksi gagal: $e");
    }
  }

  // =========================
  // DETEKSI GAMBAR (NO JWT)
  // =========================
  static Future<Map<String, dynamic>> deteksiGambar({
    required File image,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/api/deteksi");
      final request = http.MultipartRequest('POST', uri);

      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      final response = await request.send();
      final body = await response.stream.bytesToString();

      return jsonDecode(body);
    } catch (_) {
      return {"status": "error", "message": "Gagal mendeteksi gambar"};
    }
  }

  static Future<Map<String, dynamic>> buatOrder({
    required int tukangId,
    required String jenisKerusakan,
    required int estimasiHarga,
  }) async {
    try {
      final headers = await _authHeaders();

      final response = await http.post(
        Uri.parse("$baseUrl/api/orders"),
        headers: headers,
        body: jsonEncode({
          "tukang_id": tukangId,
          "jenis_kerusakan": jenisKerusakan,
          "estimasi_harga": estimasiHarga,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      return _error("Gagal membuat pesanan: $e");
    }
  }

  static Future<Map<String, dynamic>> getRiwayatOrders() async {
    try {
      final headers = await _authHeaders();

      final response = await http.get(
        Uri.parse("$baseUrl/api/orders"),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      return _error("Gagal ambil riwayat pesanan: $e");
    }
  }

  // =========================
  // CHAT
  // =========================
  static Future<Map<String, dynamic>> getChat(int orderId) async {
    try {
      final headers = await _authHeaders();
      final response = await http.get(
        Uri.parse("$baseUrl/api/chat/$orderId"),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      return _error("Gagal memuat chat");
    }
  }

  static Future<Map<String, dynamic>> kirimChat({
    required int orderId,
    required String message,
  }) async {
    try {
      final headers = await _authHeaders();
      final response = await http.post(
        Uri.parse("$baseUrl/api/chat"),
        headers: headers,
        body: jsonEncode({"order_id": orderId, "message": message}),
      );
      return _handleResponse(response);
    } catch (e) {
      return _error("Gagal mengirim pesan");
    }
  }
}
