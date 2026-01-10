import 'package:capstone/pages/riwayat_page.dart';
import 'package:flutter/material.dart';
import '../services/api.dart';

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
  int selectedPrice = 250000;

  final budgetController = TextEditingController();
  final alamatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "Form Pesanan - ${widget.namaTukang}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Jam Operasional 07:00 - 24:00",
                style: TextStyle(
                  fontSize: screenWidth < 360 ? 16 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Pilih tanggal, jam, alamat, & harga",
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 25),

              screenWidth < 600
                  ? Column(
                      children: [
                        _buildDateInput(),
                        const SizedBox(height: 20),
                        _buildTimeInput(),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: _buildDateInput()),
                        const SizedBox(width: 20),
                        Expanded(child: _buildTimeInput()),
                      ],
                    ),

              const SizedBox(height: 25),

              /// =======================
              /// INPUT ALAMAT
              /// =======================
              const Text(
                "Alamat Pekerjaan",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: alamatController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Contoh: Jl. Merdeka No.10, Bandung",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Harga Penawaran",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<int>(
                initialValue: selectedPrice,
                decoration: InputDecoration(
                  labelText: "Pilih Budget",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 250000, child: Text("Rp. 250.000")),
                  DropdownMenuItem(value: 300000, child: Text("Rp. 300.000")),
                  DropdownMenuItem(value: 0, child: Text("Custom")),
                ],
                onChanged: (value) => setState(() => selectedPrice = value!),
              ),

              if (selectedPrice == 0)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: budgetController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Input budget (mis: 500000)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedDate == null ||
                        selectedTime == null ||
                        alamatController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Lengkapi semua data")),
                      );
                      return;
                    }

                    int harga = selectedPrice == 0
                        ? int.tryParse(budgetController.text) ?? 0
                        : selectedPrice;

                    final tanggal =
                        "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    final result = await Api.buatOrder(
                      tukangId: widget.tukangId,
                      namaCustomer: "Customer", // nanti bisa ambil dari JWT
                      tanggalPengerjaan: tanggal,
                      alamat: alamatController.text,
                      hargaPerHari: harga,
                    );

                    Navigator.pop(context);

                    if (result['status'] == 'success') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const RiwayatPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            result['message'] ?? 'Gagal membuat pesanan',
                          ),
                        ),
                      );
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Kirim Pesanan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pilih Tanggal",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: "mm/dd/yyyy",
            suffixIcon: const Icon(Icons.calendar_today),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          controller: TextEditingController(
            text: selectedDate == null
                ? ""
                : "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}",
          ),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
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

  Widget _buildTimeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pilih Waktu",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: "-- : --",
            suffixIcon: const Icon(Icons.access_time),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          controller: TextEditingController(
            text: selectedTime == null ? "" : selectedTime!.format(context),
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
