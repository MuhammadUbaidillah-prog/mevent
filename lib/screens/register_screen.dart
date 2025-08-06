import 'package:flutter/material.dart';
import '../services/auth_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final studentNumberController = TextEditingController();
  final majorController = TextEditingController();
  final classYearController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await AuthService().register({
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'student_number': studentNumberController.text.trim(),
      'major': majorController.text.trim(),
      'class_year': int.tryParse(classYearController.text.trim()) ?? 0,
      'password': passwordController.text.trim(),
      'password_confirmation': confirmPasswordController.text.trim(),
    });

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );

    if (result['success']) {
      Navigator.pop(context); // Kembali ke halaman login
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    studentNumberController.dispose();
    majorController.dispose();
    classYearController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun Baru'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Header
              Text(
                'Daftar Akun Mevent',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              const Text(
                'Isi data di bawah untuk membuat akun baru',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 32),
              // Input Nama
              _buildTextFormField(
                controller: nameController,
                labelText: 'Nama',
                icon: Icons.person,
                validator: (value) =>
                value == null || value.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              // Input Email
              _buildTextFormField(
                controller: emailController,
                labelText: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                value == null || value.isEmpty ? 'Email wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              // Input NIM
              _buildTextFormField(
                controller: studentNumberController,
                labelText: 'NIM / Student Number',
                icon: Icons.tag,
                validator: (value) =>
                value == null || value.isEmpty ? 'NIM wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              // Input Jurusan
              _buildTextFormField(
                controller: majorController,
                labelText: 'Jurusan / Major',
                icon: Icons.school,
                validator: (value) =>
                value == null || value.isEmpty ? 'Jurusan wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              // Input Angkatan
              _buildTextFormField(
                controller: classYearController,
                labelText: 'Angkatan / Class Year',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? 'Angkatan wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              // Input Password
              _buildTextFormField(
                controller: passwordController,
                labelText: 'Password',
                icon: Icons.lock,
                obscureText: true,
                validator: (value) => value == null || value.length < 6
                    ? 'Password minimal 6 karakter'
                    : null,
              ),
              const SizedBox(height: 16),
              // Input Konfirmasi Password
              _buildTextFormField(
                controller: confirmPasswordController,
                labelText: 'Konfirmasi Password',
                icon: Icons.lock,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password wajib diisi';
                  }
                  if (value != passwordController.text) {
                    return 'Password tidak cocok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : handleRegister,
                  child: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Daftar',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon, color: Colors.blue[700]),
      ),
      validator: validator,
    );
  }
}