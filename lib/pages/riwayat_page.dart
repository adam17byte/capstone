import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/api.dart';
import '../widgets/bottom_nav.dart';
import 'rating_ulasan_page.dart';
import 'upload_bukti_page.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  bool isLoading = true;
  String error = '';
  List orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final result = await Api.getRiwayatOrders();
    if (!mounted) return;

    if (result['status'] == 'success') {
      final data = result['data'];
      setState(() {
        orders = data is Map && data['items'] is List
            ? data['items']
            : [];
        isLoading = false;
      });
    } else {
      setState(() {
        error = result['message'] ?? 'Gagal memuat riwayat';
        isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() => isLoading = true);
    await fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: Colors.orange,
      ),
      body: _buildBody(),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return _ErrorState(message: error, onRetry: fetchOrders);
    }

    if (orders.isEmpty) {
      return const _EmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (_, i) =>
            _OrderCard(order: orders[i], onRefresh: _refresh),
      ),
    );
  }
}

// ======================================================
// ERROR & EMPTY STATE
// ======================================================

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history, size: 40, color: Colors.grey),
          SizedBox(height: 8),
          Text('Belum ada pesanan'),
        ],
      ),
    );
  }
}

// ======================================================
// ORDER CARD FINAL
// ======================================================

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final Future<void> Function() onRefresh;

  const _OrderCard({
    required this.order,
    required this.onRefresh,
  });

  // ================= DATA =================
  String get status => (order['status'] ?? '').toString();
  String get statusPembayaran =>
      (order['status_pembayaran'] ?? 'belum_bayar').toString();
  String get metodePembayaran =>
      (order['metode_pembayaran'] ?? 'transfer').toString();

  bool get isSelesai => status == 'selesai';
  bool get isDiterima => status == 'diterima';
  bool get isDitolak => status == 'ditolak';

  bool get perluUploadBukti =>
      metodePembayaran == 'transfer' &&
      isDiterima &&
      statusPembayaran == 'belum_bayar';

  // ================= FORMAT =================
  String _formatTanggal(String? raw) {
    if (raw == null) return '-';
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }

  String _formatRupiah(dynamic value) {
    final n = int.tryParse(value.toString());
    if (n == null) return '-';
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(n);
  }

  Color _statusColor() {
    if (isSelesai) return Colors.green;
    if (isDitolak) return Colors.red;
    return Colors.orange;
  }

  String _statusLabel() {
    switch (status) {
      case 'menunggu_konfirmasi':
        return 'Menunggu Konfirmasi';
      case 'diterima':
        return 'Diterima';
      case 'ditolak':
        return 'Ditolak';
      case 'menuju_lokasi':
        return 'Menuju Lokasi';
      case 'dalam_pengerjaan':
        return 'Sedang Dikerjakan';
      case 'selesai':
        return 'Selesai';
      default:
        return status;
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final rating = order['rating'];
    final ulasan = order['ulasan'];

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              children: [
                Expanded(
                  child: Text(
                    order['nama_tukang'] ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    _statusLabel(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: _statusColor(),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Text("Tanggal: ${_formatTanggal(order['tanggal_pengerjaan'])}"),
            Text("Harga: ${_formatRupiah(order['harga_per_hari'])}"),
            Text("Pembayaran: ${metodePembayaran.toUpperCase()}"),

            // UPLOAD BUKTI (TRANSFER ONLY)
            if (perluUploadBukti) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () async {
                    final ok = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UploadBuktiPage(
                          pesananId: order['id_pesanan'],
                        ),
                      ),
                    );
                    if (ok == true) {
                      await onRefresh();
                    }
                  },
                  child: const Text(
                    "Upload Bukti Pembayaran",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],

            // RATING
            if (isSelesai && (rating == null || ulasan == null)) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () async {
                    final ok = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RetingUlasanPage(
                          orderId: order['id_pesanan'],
                          tukangId: order['tukang_id'],
                          namaTukang: order['nama_tukang'],
                        ),
                      ),
                    );
                    if (ok == true) {
                      await onRefresh();
                    }
                  },
                  child: const Text(
                    "Beri Rating & Ulasan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],

            // HASIL RATING
            if (rating != null && ulasan != null) ...[
              const Divider(height: 20),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 18),
                  const SizedBox(width: 4),
                  Expanded(child: Text("$rating/5 -\"$ulasan\"")),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}