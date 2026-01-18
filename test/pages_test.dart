import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:capstone/pages/home_page.dart';
import 'package:capstone/pages/splash_page.dart';
import 'package:capstone/pages/profil_page.dart';
import 'dart:io';
import 'package:capstone/pages/notifikasi_page.dart';
import 'package:capstone/pages/riwayat_page.dart';
import 'package:capstone/pages/rekomendasi_page.dart';
import 'package:capstone/pages/form_pesanan_page.dart';
import 'package:capstone/pages/edit_profil_page.dart';
import 'package:capstone/pages/upload_bukti_page.dart';
import 'package:capstone/pages/hasil_deteksi_page.dart';
// import 'dart:typed_data';
import 'package:capstone/pages/deteksi_page.dart';
import 'package:capstone/pages/panduan_deteksi_page.dart';
import 'package:capstone/pages/panduan_mitra_page.dart';
import 'package:capstone/pages/profil_tukang_page.dart';
import 'package:capstone/pages/rating_ulasan_page.dart';
import 'package:capstone/pages/artikel_kerusakan_awal_page.dart';
import 'package:capstone/pages/artikel_renovasi_aman_page.dart';
import 'package:capstone/pages/chat_page.dart';
import 'package:capstone/pages/chat_room_page.dart';
import 'package:capstone/pages/chatbot_page.dart';

void main() {
  testWidgets('HomePage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
  });
  testWidgets('SplashPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashPage()));
    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(SplashPage), findsOneWidget);
  });
  testWidgets('ProfilPage renders', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: 800,
              child: ProfilPage(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ProfilPage), findsOneWidget);
  });
  testWidgets('NotifikasiPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: NotifikasiPage()));
    expect(find.byType(NotifikasiPage), findsOneWidget);
  });
  testWidgets('RiwayatPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RiwayatPage()));
    expect(find.byType(RiwayatPage), findsOneWidget);
  });
  testWidgets('RekomendasiPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RekomendasiPage(jenisKerusakan: 'Retak')));
    expect(find.byType(RekomendasiPage), findsOneWidget);
  });
  testWidgets('FormPesananPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: FormPesananPage(namaTukang: 'Budi', tukangId: 1, jenisKerusakan: 'Retak')));
    expect(find.byType(FormPesananPage), findsOneWidget);
  });
  testWidgets('EditProfilPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: EditProfilPage()));
    expect(find.byType(EditProfilPage), findsOneWidget);
  });
  testWidgets('UploadBuktiPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: UploadBuktiPage(pesananId: 1)));
    expect(find.byType(UploadBuktiPage), findsOneWidget);
  });
  testWidgets('HasilDeteksiPage renders', (tester) async {
    final dummyFile = File('assets/images/logo_temantukang.png');
    await tester.pumpWidget(MaterialApp(
      home: HasilDeteksiPage(
        hasilLabel: 'Retak',
        confidence: 0.9,
        imageFile: dummyFile,
      ),
    ));
    expect(find.byType(HasilDeteksiPage), findsOneWidget);
  });
  testWidgets('DeteksiPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DeteksiPage()));
    expect(find.byType(DeteksiPage), findsOneWidget);
  });
  testWidgets('PanduanDeteksiPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PanduanDeteksiPage()));
    expect(find.byType(PanduanDeteksiPage), findsOneWidget);
  });
  testWidgets('PanduanMitraPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PanduanMitraPage()));
    expect(find.byType(PanduanMitraPage), findsOneWidget);
  });
  testWidgets('ProfilTukangPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfilTukangPage(idTukang: 1)));
    expect(find.byType(ProfilTukangPage), findsOneWidget);
  });
  testWidgets('RatingUlasanPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RetingUlasanPage(orderId: 1, tukangId: 1, namaTukang: 'Budi')));
    expect(find.byType(RetingUlasanPage), findsOneWidget);
  });
  testWidgets('ArtikelKerusakanAwalPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ArtikelKerusakanAwalPage()));
    expect(find.byType(ArtikelKerusakanAwalPage), findsOneWidget);
  });
  testWidgets('ArtikelRenovasiAmanPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ArtikelRenovasiAmanPage()));
    expect(find.byType(ArtikelRenovasiAmanPage), findsOneWidget);
  });
  testWidgets('ChatPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatPage()));
    expect(find.byType(ChatPage), findsOneWidget);
  });
  testWidgets('ChatRoomPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatRoomPage(pesananId: 1, chatName: 'Test')));
    expect(find.byType(ChatRoomPage), findsOneWidget);
  });
  testWidgets('ChatbotPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatbotPage()));
    expect(find.byType(ChatbotPage), findsOneWidget);
  });
}