# 📱 Aplikasi Absensi Komunitas

Aplikasi Absensi Komunitas adalah aplikasi mobile berbasis **Flutter** yang digunakan untuk membantu organisasi, UKM, atau komunitas kampus dalam **mengelola data anggota dan mencatat kehadiran** secara digital dan terpusat.

Aplikasi ini dirancang agar dapat digunakan oleh **pengurus (misalnya sekretaris)** untuk mempermudah proses administrasi absensi yang sebelumnya dilakukan secara manual.

---

## 🎯 Tujuan Aplikasi

- Mengelola data anggota komunitas
- Mencatat kehadiran anggota per tanggal
- Menyimpan data absensi secara aman dan terpusat
- Menampilkan laporan absensi yang mudah dibaca

Aplikasi ini menyelesaikan **masalah nyata** berupa pencatatan absensi manual yang tidak efisien dan rawan kesalahan.

---

## ✨ Fitur Utama

- 🔐 **Autentikasi**
  - Login & registrasi menggunakan email dan password (Firebase Authentication)

- 👥 **Manajemen Anggota (CRUD)**
  - Menambah anggota
  - Melihat daftar anggota
  - Menghapus anggota

- 📝 **Absensi Anggota**
  - Pilih tanggal absensi
  - Pilih status kehadiran (Hadir, Izin, Sakit, Alfa)
  - Simpan data absensi ke database

- 📊 **Laporan Absensi**
  - Melihat hasil absensi berdasarkan tanggal
  - Data bersifat read-only (arsip)

---

## 🧠 State Management

Aplikasi ini menggunakan **Provider** sebagai state management untuk:
- Autentikasi pengguna
- Data anggota
- Data absensi

Penggunaan Provider membuat struktur kode lebih rapi dan mudah dikelola.

---

## 🗄️ Database

Aplikasi menggunakan **Firebase** sebagai backend:
- **Firebase Authentication** → Autentikasi pengguna
- **Cloud Firestore** → Penyimpanan data anggota dan absensi

Data bersifat **terpusat (global)** sehingga dapat diakses oleh pengguna yang memiliki akun.

---

## 🖼️ UI / UX

- Menggunakan Material Design
- Tampilan sederhana, rapi, dan konsisten
- Navigasi mudah menggunakan Drawer Menu
- Cocok untuk aplikasi sistem informasi kampus

---

## 🛠️ Teknologi yang Digunakan

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- Provider (State Management)

---

## ▶️ Cara Menjalankan Aplikasi

1. Clone repository ini
2. Jalankan perintah:
   ```bash
   flutter pub get

Jalankan aplikasi:
flutter run
flutter run -d chrome


👩‍🎓 Identitas Pengembang

Nama : Dinda Afrilia
NIM : 2317020127
Program Studi : Sistem Informasi
Fakultas : Sains dan Teknologi
Universitas : UIN Imam Bonjol Padang

📌 Catatan

Aplikasi ini dibuat untuk memenuhi tugas Pemrograman Mobile (Flutter) dan dapat dikembangkan lebih lanjut dengan fitur seperti role pengguna (admin/viewer) dan export laporan absensi.