import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  // =========================
  // BASE URL
  // =========================
  static const String baseUrl = "https://witted-gentler-jeanett.ngrok-free.dev";

  static const Duration timeoutDuration = Duration(seconds: 365);

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

  // =================================================
  // AUTH
  // =================================================
  static Future<Map<String, dynamic>> register({
    required String nama,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/register"),
        headers: _jsonHeaders,
        body: jsonEncode({"nama": nama, "email": email, "password": password}),
      );

      return _handleResponse(response);
    } catch (_) {
      return _error("Koneksi gagal");
    }
  }

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
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (_) {
      return _error("Koneksi gagal");
    }
  }

  static Future<Map<String, dynamic>> loginGoogle({
    required String idToken,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/google"),
        headers: _jsonHeaders,
        body: jsonEncode({"id_token": idToken}),
      );

      return _handleResponse(response);
    } catch (_) {
      return _error("Koneksi gagal");
    }
  }

  // =================================================
  // REKOMENDASI TUKANG
  // =================================================
  static Future<Map<String, dynamic>> getRekomendasi({
    required String jenisKerusakan,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/rekomendasi"),
        headers: {..._jsonHeaders, "Authorization": "Bearer $token"},
        body: jsonEncode({"jenis_kerusakan": jenisKerusakan}),
      );

      return _handleResponse(response);
    } catch (_) {
      return _error("Gagal ambil rekomendasi");
    }
  }

  // =================================================
  // DETEKSI GAMBAR
  // =================================================
  static Future<Map<String, dynamic>> deteksiGambar({
    required File image,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/api/deteksi");
      final request = http.MultipartRequest("POST", uri);

      request.files.add(await http.MultipartFile.fromPath("file", image.path));

      final response = await request.send();
      final body = await response.stream.bytesToString();

      return jsonDecode(body);
    } catch (_) {
      return _error("Gagal mendeteksi gambar");
    }
  }

  // =================================================
  // BUAT PESANAN (FIX TOTAL)
  // =================================================
  static Future<Map<String, dynamic>> buatOrder({
    required int tukangId,
    required String namaCustomer,
    required String alamat,
    required String tanggalPengerjaan,
    required int hargaPerHari,
    required String metodePembayaran,
  }) async {
    try {
      final headers = await _authHeaders();

      final response = await http.post(
        Uri.parse("$baseUrl/api/pesanan"),
        headers: headers,
        body: jsonEncode({
          "tukang_id": tukangId,
          "nama_customer": namaCustomer,
          "alamat": alamat,
          "tanggal_pengerjaan": tanggalPengerjaan,
          "harga_per_hari": hargaPerHari,
          "metode_pembayaran": metodePembayaran,
        }),
      );

      return _handleResponse(response);
    } catch (_) {
      return _error("Gagal membuat pesanan");
    }
  }

  static Future<Map<String, dynamic>> uploadBuktiPembayaran({
    required int pesananId,
    required File file,
  }) async {
    try {
      final headers = await _authHeaders();

      final request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/api/pesanan/upload-bukti/$pesananId"),
      );

      request.headers.addAll(headers);
      request.files.add(
        await http.MultipartFile.fromPath("bukti_pembayaran", file.path),
      );

      final response = await request.send();
      final body = await response.stream.bytesToString();

      return jsonDecode(body);
    } catch (_) {
      return {"status": "error", "message": "Gagal upload bukti pembayaran"};
    }
  }

  // =================================================
  // RIWAYAT PESANAN CUSTOMER (FIX)
  // =================================================
  static Future<Map<String, dynamic>> getRiwayatOrders() async {
    try {
      final headers = await _authHeaders();

      final response = await http.get(
        Uri.parse("$baseUrl/api/customer/pesanan"),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (_) {
      return _error("Gagal ambil riwayat pesanan");
    }
  }

  // =================================================
  // REVIEW
  // =================================================
  static Future<Map<String, dynamic>> kirimReview({
    required int pesananId,
    required int tukangId,
    required String reviewText,
    required int rating,
  }) async {
    try {
      final headers = await _authHeaders();

      final response = await http.post(
        Uri.parse("$baseUrl/api/review"),
        headers: headers,
        body: jsonEncode({
          "pesanan_id": pesananId,
          "tukang_id": tukangId,
          "review_text": reviewText,
          "rating": rating,
        }),
      );

      return _handleResponse(response);
    } catch (_) {
      return _error("Gagal mengirim review");
    }
  }

  static Future<Map<String, dynamic>> getTukangProfilePublic({
    required int idTukang,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/tukang/$idTukang"),
        headers: {..._jsonHeaders, "Authorization": "Bearer $token"},
      );
      return _handleResponse(response);
    } catch (_) {
      return _error("Gagal memuat profil tukang");
    }
  }

  static Future<Map<String, dynamic>> getHomePesanan() async {
    try {
      final headers = await _authHeaders();
      final response = await http.get(
        Uri.parse("$baseUrl/api/customer/home"),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (_) {
      return _error("Gagal mengambil daftar chat");
    }
  }

  // =================================================
  // CHAT
  // =================================================
  static Future<Map<String, dynamic>> getChat(int pesananId) async {
    try {
      final headers = await _authHeaders();
      final response = await http.get(
        Uri.parse("$baseUrl/api/chat/$pesananId"),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      return _error("Gagal memuat chat");
    }
  }

  static Future<Map<String, dynamic>> sendChat({
    required int pesananId,
    required String message,
  }) async {
    try {
      final headers = await _authHeaders();
      final response = await http.post(
        Uri.parse("$baseUrl/api/chat"),
        headers: headers,
        body: jsonEncode({"pesanan_id": pesananId, "message": message}),
      );
      return _handleResponse(response);
    } catch (e) {
      return _error("Gagal mengirim pesan");
    }
  }

  static Future<Map<String, dynamic>> getNotifikasi() async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse("$baseUrl/api/notifikasi"),
      headers: headers,
    );
    return _handleResponse(response);
  }

  // ================= CHECK TOKEN =================
  static Future<bool> checkToken() async {
    try {
      final headers = await _authHeaders();
      final response = await http.get(
        Uri.parse("$baseUrl/api/auth/check"),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // =================================================
  // CHATBOT (HUGGING FACE)
  // =================================================
  static Future<Map<String, dynamic>> sendChatbot({
    required String query,
  }) async {
    try {
      final headers = await _authHeaders();

      final response = await http
          .post(
            Uri.parse("$baseUrl/api/chatbot"),
            headers: headers,
            body: jsonEncode({"query": query}),
          )
          .timeout(timeoutDuration);

      return _handleResponse(response);
    } on SocketException {
      return _error("Tidak ada koneksi internet");
    } on HttpException {
      return _error("Server error");
    } on FormatException {
      return _error("Format response salah");
    } catch (_) {
      return _error("Chatbot gagal merespons");
    }
  }
}