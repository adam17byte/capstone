class Tukang {
  final int id;
  final String nama;
  final String keahlian;
  final String pengalaman;
  final double rating;
  final String foto;

  Tukang({
    required this.id,
    required this.nama,
    required this.keahlian,
    required this.pengalaman,
    required this.rating,
    required this.foto,
  });

  factory Tukang.fromJson(Map<String, dynamic> json) {
    return Tukang(
      id: json["id_tukang"] is int
          ? json["id_tukang"]
          : int.parse(json["id_tukang"].toString()),

      nama: json["nama"]?.toString() ?? "",
      keahlian: json["keahlian"]?.toString() ?? "",
      pengalaman: json["pengalaman"]?.toString() ?? "",

      // 🔥 FIX UTAMA DI SINI
      rating: json["rating"] == null
          ? 0.0
          : double.tryParse(json["rating"].toString()) ?? 0.0,

      foto: json["foto"]?.toString() ?? "",
    );
  }
}