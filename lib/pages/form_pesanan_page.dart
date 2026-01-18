import 'package:flutter/material.dart';
import '../services/api.dart';
import 'riwayat_page.dart';

class FormPesananPage extends StatefulWidget {
  final String namaTukang;
  final int tukangId;
  final String jenisKerusakan;

  const FormPesananPage({
    super.key,
    required this.namaTukang,
    required this.tukangId,
    required this.jenisKerusakan,
  });

  @override
  State<FormPesananPage> createState() => _FormPesananPageState();
}

class _FormPesananPageState extends State<FormPesananPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  int selectedPrice = 150000;
  String metodePembayaran = 'transfer';

  final TextEditingController alamatController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    alamatController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (selectedDate == null || alamatController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Lengkapi semua data")));
      return;
    }

    final harga = selectedPrice == 0
        ? int.tryParse(budgetController.text) ?? 0
        : selectedPrice;

    if (harga <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Harga tidak valid")));
      return;
    }

    // 🔒 SAFETY: pastikan metode valid
    if (metodePembayaran != 'cash' && metodePembayaran != 'transfer') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Metode pembayaran tidak valid")),
      );
      return;
    }

    final tanggal =
        "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

    setState(() => isLoading = true);

    final result = await Api.buatOrder(
      tukangId: widget.tukangId,
      namaCustomer: "Customer",
      alamat: alamatController.text,
      tanggalPengerjaan: tanggal, // ⬅️ DATE ONLY
      hargaPerHari: harga,
      metodePembayaran: metodePembayaran, // cash / transfer
    );

    setState(() => isLoading = false);

    if (result['status'] == 'success') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const RiwayatPage()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal membuat pesanan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Pesan ${widget.namaTukang}"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Detail Pesanan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _dateInput(),
              const SizedBox(height: 16),
              _timeInput(),
              const SizedBox(height: 20),

              const Text("Alamat Pekerjaan"),
              const SizedBox(height: 6),
              TextField(
                controller: alamatController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Alamat lengkap lokasi pekerjaan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Harga Penawaran"),
              const SizedBox(height: 6),
              DropdownButtonFormField<int>(
                value: selectedPrice,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 100000, child: Text("Rp 100.000")),
                  DropdownMenuItem(value: 150000, child: Text("Rp 150.000")),
                  DropdownMenuItem(value: 0, child: Text("Custom")),
                ],
                onChanged: (v) => setState(() => selectedPrice = v!),
              ),

              if (selectedPrice == 0) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: budgetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Masukkan budget",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              const Text("Metode Pembayaran"),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: metodePembayaran,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'transfer',
                    child: Text("Transfer Bank"),
                  ),
                  DropdownMenuItem(
                    value: 'cash',
                    child: Text("Bayar di Tempat"),
                  ),
                ],
                onChanged: (v) => setState(() => metodePembayaran = v!),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Kirim Pesanan",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Tanggal Pengerjaan"),
        const SizedBox(height: 6),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: selectedDate == null
                ? "Pilih tanggal"
                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
            suffixIcon: const Icon(Icons.calendar_today),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              initialDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() => selectedDate = picked);
            }
          },
        ),
      ],
    );
  }

  Widget _timeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Jam Pengerjaan"),
        const SizedBox(height: 6),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: selectedTime == null
                ? "Pilih jam"
                : selectedTime!.format(context),
            suffixIcon: const Icon(Icons.access_time),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) {
              setState(() => selectedTime = picked);
            }
          },
        ),
      ],
    );
  }
}