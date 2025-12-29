# Teman Tukang - Customer App

Aplikasi mobile Flutter untuk pelanggan yang membutuhkan jasa tukang profesional. Aplikasi ini menyediakan fitur deteksi kerusakan bangunan menggunakan AI, pencarian tukang terdekat, chat real-time, dan sistem pemesanan jasa.

## 🚀 Fitur Utama

### 🔍 Deteksi Kerusakan
- Deteksi kerusakan bangunan menggunakan TensorFlow Lite
- Analisis faktor penyebab kerusakan
- Rekomendasi perbaikan

### 👷‍♂️ Pencarian Tukang
- Cari tukang berdasarkan lokasi
- Lihat profil dan rating tukang
- Sistem rekomendasi tukang terbaik

### 💬 Chat & Komunikasi
- Chat real-time dengan tukang
- Kirim gambar kerusakan
- Diskusi proyek

### 📋 Sistem Pemesanan
- Form pemesanan jasa lengkap
- Pilih budget dan jadwal
- Tracking status pemesanan

### 🔐 Autentikasi
- Login/Register dengan email
- Google Sign-In
- Secure storage untuk data pengguna

## 🛠️ Teknologi yang Digunakan

- **Framework**: Flutter
- **Bahasa**: Dart
- **AI/ML**: TensorFlow Lite
- **Backend**: REST API (Flask)
- **Database**: Shared Preferences (local)
- **Authentication**: Google Sign-In
- **State Management**: Provider (implisit)

## 📱 Platform

- Android (primary)
- iOS (supported)

## 🚀 Instalasi & Setup

### Prerequisites
- Flutter SDK (versi 3.9.2+)
- Android Studio / VS Code
- Android SDK
- Git

### Langkah Instalasi

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd customer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup Firebase (jika diperlukan)**
   - Copy `google-services.json` ke `android/app/`
   - Konfigurasi Firebase project

4. **Setup AI Model**
   - Pastikan file `best.tflite` dan `labels.txt` ada di `assets/models/`

5. **Run aplikasi**
   ```bash
   flutter run
   ```

## 📂 Struktur Proyek

```
lib/
├── auth/                 # Halaman autentikasi
│   ├── login_page.dart
│   ├── register_page.dart
│   └── forgot_password_page.dart
├── models/               # Model data
│   └── tukang.dart
├── pages/                # Halaman utama aplikasi
│   ├── home_page.dart
│   ├── deteksi_page.dart
│   ├── chat_page.dart
│   └── ...
├── services/             # Service layer
│   ├── api.dart
│   └── google_auth_service.dart
├── widgets/              # Widget reusable
│   └── bottom_nav.dart
└── main.dart             # Entry point aplikasi
```

## 🔧 Build & Deploy

### Debug Build
```bash
flutter build apk --debug
```

### Release Build
```bash
flutter build apk --release
```

### Build untuk iOS
```bash
flutter build ios
```

## 📊 API Integration

Aplikasi terintegrasi dengan backend Flask yang menyediakan:
- User authentication
- Tukang data management
- Chat system
- Order management

**Base URL**: `https://witted-gentler-jeanett.ngrok-free.dev`

## 🤝 Kontribusi

1. Fork repository
2. Buat branch fitur (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## 📝 Lisensi

Distributed under the MIT License. See `LICENSE` for more information.

## 👥 Tim Pengembang

- **Developer**: Capstone Team
- **Project**: Teman Tukang - Customer App
- **Tahun**: 2025

## 📞 Kontak

- **Email**: [your-email@example.com]
- **GitHub**: [your-github-username]

---

**Catatan**: Pastikan backend server aktif sebelum menjalankan aplikasi untuk fitur yang memerlukan koneksi internet.
