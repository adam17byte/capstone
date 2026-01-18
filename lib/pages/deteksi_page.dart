import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '../widgets/bottom_nav.dart';
import 'hasil_deteksi_page.dart';

class DeteksiPage extends StatefulWidget {
  const DeteksiPage({super.key});

  @override
  State<DeteksiPage> createState() => _DeteksiPageState();
}

class _DeteksiPageState extends State<DeteksiPage> {
  final ImagePicker _picker = ImagePicker();

  io.File? _imageFile;
  Interpreter? _interpreter;

  bool _isModelLoaded = false;
  bool _isDetecting = false;

  int _inputSize = 224;
  final List<String> _labels = [];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      final labelData = await DefaultAssetBundle.of(
        context,
      ).loadString('assets/models/labels.txt');

      _labels
        ..clear()
        ..addAll(
          labelData.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty),
        );

      _interpreter = await Interpreter.fromAsset('assets/models/best.tflite');

      final inputShape = _interpreter!.getInputTensor(0).shape;
      final outputShape = _interpreter!.getOutputTensor(0).shape;

      if (inputShape.length == 4) {
        _inputSize = inputShape[1];
      }

      if (outputShape[1] != _labels.length) {
        throw Exception("Label tidak cocok dengan output model");
      }

      _isModelLoaded = true;
    } catch (_) {
      _isModelLoaded = false;
    }
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        _imageFile = io.File(picked.path);
      });
    }
  }

  Future<void> _detectImage() async {
    if (!_isModelLoaded || _imageFile == null || _isDetecting) return;

    setState(() => _isDetecting = true);

    try {
      final bytes = await _imageFile!.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) throw Exception("Gagal decode gambar");

      final resized = img.copyResize(
        image,
        width: _inputSize,
        height: _inputSize,
      );

      final input = List.generate(
        1,
        (_) => List.generate(
          _inputSize,
          (y) => List.generate(_inputSize, (x) {
            final p = resized.getPixel(x, y);
            return [p.r / 255, p.g / 255, p.b / 255];
          }),
        ),
      );

      final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));

      _interpreter!.run(input, output);

      final scores = output[0];
      int bestIndex = 0;
      double bestScore = scores[0];

      for (int i = 1; i < scores.length; i++) {
        if (scores[i] > bestScore) {
          bestScore = scores[i];
          bestIndex = i;
        }
      }

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HasilDeteksiPage(
            imageFile: _imageFile!,
            hasilLabel: _labels[bestIndex],
            confidence: bestScore,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan saat deteksi")),
      );
    } finally {
      if (mounted) {
        setState(() => _isDetecting = false);
      }
    }
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool canDetect = _imageFile != null && !_isDetecting;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Deteksi"),
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ImagePreview(imageFile: _imageFile),
            const Spacer(),

            // Pilih / Ubah Gambar
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                _imageFile == null ? "Pilih Gambar" : "Ubah Gambar",
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 12),

            // Deteksi Button
            IgnorePointer(
              ignoring: !canDetect,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton(
                  onPressed: _detectImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canDetect
                        ? Colors.orange
                        : Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: canDetect ? 2 : 0,
                  ),
                  child: _isDetecting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Deteksi",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final io.File? imageFile;

  const _ImagePreview({this.imageFile});

  @override
  Widget build(BuildContext context) {
    if (imageFile == null) {
      return Container(
        height: 300,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Text(
          "Belum ada gambar",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        imageFile!,
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}