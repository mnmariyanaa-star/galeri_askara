import 'package:flutter/material.dart';
import 'home_screen.dart'; // Pastikan file home_screen.dart ada

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorText;

  // Untuk efek fokus biru
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validasi: cek email dan password tidak kosong & format email benar
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorText = 'Email dan password tidak boleh kosong';
      });
    } else if (!email.contains('@') || !email.contains('.')) {
      setState(() {
        _errorText = 'Format email tidak valid';
      });
    } else {
      setState(() {
        _errorText = null; // Reset error
      });
      // Login berhasil, masuk ke HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            children: [
              const SizedBox(height: 60),
              Image.asset('img/assets/logo.png', height: 250),
              const SizedBox(height: 24),
              const Text(
                'Create an account',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Enter your email to sign up for this app',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                focusNode: _emailFocus,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => _passwordFocus.requestFocus(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleLogin(),
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 10),
                Text(_errorText!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Continue', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
              const Center(child: Text('or')),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _errorText = "Login Google belum diaktifkan!";
                  });
                },
                icon: Image.asset('img/assets/google_icon.png', height: 24),
                label: const Text('Continue with Google'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200]),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _errorText = "Login Apple belum diaktifkan!";
                  });
                },
                icon: Image.asset('img/assets/apple_icon.png', height: 24),
                label: const Text('Continue with Apple'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200]),
              ),
              const SizedBox(height: 20),
              const Text.rich(
                TextSpan(
                  text: 'By clicking continue, you agree to our ',
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
