import 'package:flutter/material.dart';
import 'package:mevent/screens/login_screeen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'event_list_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Memberikan delay 3 detik agar splash screen terlihat
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      // ✅ Jika sudah login, langsung ke halaman daftar event
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const EventListPage()),
      );
    } else {
      // ❌ Jika belum login, arahkan ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 🎨 Latar belakang putih bersih
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pastikan Anda menempatkan file logo di assets/images/mevent_logo.png
            Image.asset(
              'assets/images/mevent.png',
              width: 200, // Sesuaikan ukuran logo
              height: 200,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // 🎨 Warna loading biru
            ),
          ],
        ),
      ),
    );
  }
}