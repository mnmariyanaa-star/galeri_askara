import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Pastikan LoginScreen sudah di-import

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({Key? key}) : super(key: key);

  @override
  _SplashScreen2State createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  void initState() {
    super.initState();
    // Menunggu beberapa detik sebelum navigasi ke LoginScreen
    Future.delayed(const Duration(seconds: 3), () {
      // Pindah ke LoginScreen setelah 3 detik
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const  LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('img/assets/onboarding_circle.png', height: 450),
            const SizedBox(height: 30),
            const Text(
              'Ceritakan Karyamu ke Dunia Sekarang',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Melalui '),
                  TextSpan(
                    text: 'Galeri Askara !',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke LoginScreen setelah tombol ditekan
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Next !', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
