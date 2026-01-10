import 'package:flutter/material.dart';
import '../services/api.dart';
import 'rating_ulasan_page.dart';
import '../widgets/bottom_nav.dart';

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

    if (result['status'] == 'success') {
      setState(() {
        orders = result['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        error = result['message'];
        isLoading = false;
      });
    }
  }

  // Optionally refresh orders after giving rating/review
  Future<void> _refreshAfterRating() async {
    setState(() {
      isLoading = true;
    });
    await fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: Colors.orange,
      ),
      body: _RiwayatBody(
        isLoading: isLoading,
        error: error,
        orders: orders,
        onRetry: fetchOrders,
        onRefreshAfterRating: _refreshAfterRating,
      ),
      // Tambahkan bottom navigation bar di sini
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}

class _RiwayatBody extends StatelessWidget {
  final bool isLoading;
  final String error;
  final List orders;
  final Future<void> Function() onRetry;
  final Future<void> Function() onRefreshAfterRating;

  const _RiwayatBody({
    required this.isLoading,
    required this.error,
    required this.orders,
    required this.onRetry,
    required this.onRefreshAfterRating,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return _RiwayatError(message: error, onRetry: onRetry);
    }

    if (orders.isEmpty) {
      return const _RiwayatEmpty();
    }

    return RefreshIndicator(
      onRefresh: onRefreshAfterRating,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _OrderCard(
            order: order,
            onRefreshAfterRating: onRefreshAfterRating,
          );
        },
      ),
    );
  }
}

class _RiwayatError extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _RiwayatError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await onRetry();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiwayatEmpty extends StatelessWidget {
  const _RiwayatEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.history, size: 40, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            'Belum ada pesanan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final Future<void> Function() onRefreshAfterRating;

  const _OrderCard({required this.order, required this.onRefreshAfterRating});

  @override
  Widget build(BuildContext context) {
    final bool sudahSelesai =
        (order['status']?.toString().toLowerCase() ?? '') == 'selesai';
    final bool sudahRating = order['rating'] != null;
    final bool sudahUlasan = order['ulasan'] != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order['nama_tukang']?.toString() ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    order['status']?.toString() ?? '-',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: sudahSelesai
                      ? Colors.green
                      : Colors.orangeAccent,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "Tanggal: ${order['tanggal_pengerjaan']}",
              style: const TextStyle(fontSize: 13),
            ),
            Text(
              "Harga: Rp ${order['harga_per_hari']}",
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            if (sudahSelesai && (!sudahRating || !sudahUlasan))
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    int? _asInt(dynamic value) {
                      if (value == null) return null;
                      if (value is int) return value;
                      if (value is num) return value.toInt();
                      final s = value.toString();
                      final cleaned = s.contains('.') ? s.split('.').first : s;
                      return int.tryParse(cleaned);
                    }

                    final rawOrderId =
                        order['id'] ??
                        order['id_pesanan'] ??
                        order['pesanan_id'] ??
                        order['order_id'] ??
                        order['id_order'];
                    final rawTukangId =
                        order['tukang_id'] ??
                        order['id_tukang'];
                    final namaTukang = order['nama_tukang']?.toString() ?? '';

                    final intTukangId = _asInt(rawTukangId);
                    final intOrderId = _asInt(rawOrderId) ?? 0;

                    if (intTukangId == null) {
                      print('DEBUG ORDER (TUKANG ID INVALID): $order');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Error: ID tukang tidak valid untuk review.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (namaTukang.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error: Nama tukang tidak ditemukan'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RetingUlasanPage(
                          orderId: intOrderId,
                          tukangId: intTukangId,
                          namaTukang: namaTukang,
                        ),
                      ),
                    );

                    if (result == true) {
                      await onRefreshAfterRating();
                    }
                  },
                  child: const Text(
                    "Beri Rating & Ulasan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            if (sudahRating && sudahUlasan) ...[
              const Divider(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 20),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "${order['rating']}/5 - \"${order['ulasan']}\"",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
