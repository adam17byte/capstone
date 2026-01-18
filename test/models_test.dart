import 'package:flutter_test/flutter_test.dart';
import 'package:capstone/models/tukang.dart';

void main() {
  test('Tukang model can be instantiated', () {
    final tukang = Tukang(
      id: 1,
      nama: 'Budi',
      keahlian: 'Tukang Kayu',
      pengalaman: '5 tahun',
      rating: 4.5,
      foto: 'foto.jpg',
    );
    expect(tukang, isA<Tukang>());
  });
}