import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api.dart';

class UploadBuktiPage extends StatefulWidget {
  final int pesananId;

  const UploadBuktiPage({
    super.key,
    required this.pesananId,
  });

  @override
  State<UploadBuktiPage> createState() => _UploadBuktiPageState();
}

class _UploadBuktiPageState extends State<UploadBuktiPage> {
  File? _file;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFile() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // kompres ringan
    );

    if (picked != null) {
      final file = File(picked.path);

      // VALIDASI SIZE CLIENT (DOUBLE SECURITY)
      final size = await file.length();
      if (size > 5 * 1024 * 1024) {
        _showError("Ukuran file maksimal 2MB");
        return;
      }

      setState(() => _file = file);
    }
  }

  Future<void> _upload() async {
    if (_file == null) {
      _showError("Pilih file terlebih dahulu");
      return;
    }

    setState(() => isLoading = true);

    final result = await Api.uploadBuktiPembayaran(
      pesananId: widget.pesananId,
      file: _file!,
    );

    setState(() => isLoading = false);

    if (result["status"] == "success") {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bukti pembayaran berhasil diupload")),
      );
      Navigator.pop(context, true); // trigger refresh
    } else {
      _showError(result["message"] ?? "Upload gagal");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Bukti Pembayaran"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _file == null
                  ? const Center(
                      child: Text(
                        "Belum ada file",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _file!,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text("Pilih Bukti Pembayaran"),
                onPressed: isLoading ? null : _pickFile,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _upload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Upload Sekarang",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}