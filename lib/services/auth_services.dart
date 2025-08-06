import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://103.160.63.165/api';

  // ✅ REGISTER
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/register');
    final body = jsonEncode(data);

    print('📡 Sending REGISTER request to $url');
    print('📤 Payload: $body');

    try {
      final response = await http
          .post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      )
          .timeout(const Duration(seconds: 10));

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Register berhasil',
        };
      } else {
        try {
          final error = jsonDecode(response.body);
          return {
            'success': false,
            'message': error['message'] ?? 'Register gagal',
          };
        } catch (_) {
          return {
            'success': false,
            'message': 'Gagal parsing error dari server.',
          };
        }
      }
    } on TimeoutException catch (_) {
      return {
        'success': false,
        'message': 'Permintaan timeout. Coba lagi nanti.',
      };
    } catch (e, stacktrace) {
      print('❌ Caught exception: $e');
      print('🧩 Stacktrace: $stacktrace');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // ✅ LOGIN
  Future<Map<String, dynamic>> login(
      String studentNumber,
      String password,
      ) async {
    final url = Uri.parse('$baseUrl/login');
    final body = jsonEncode({
      'student_number': studentNumber,
      'password': password,
    });

    print('📡 Sending LOGIN request to $url');
    print('📤 Payload: $body');

    try {
      final response = await http
          .post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      )
          .timeout(const Duration(seconds: 10));

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['data']?['token'];

        if (token != null) {
          return {
            'success': true,
            'message': data['message'] ?? 'Login berhasil',
            'token': token,
          };
        } else {
          return {
            'success': false,
            'message': 'Login berhasil tapi token tidak ditemukan.',
          };
        }
      } else {
        try {
          final error = jsonDecode(response.body);
          return {
            'success': false,
            'message': error['message'] ?? 'Login gagal',
          };
        } catch (_) {
          return {
            'success': false,
            'message': 'Gagal parsing error dari server.',
          };
        }
      }
    } on TimeoutException catch (_) {
      return {
        'success': false,
        'message': 'Permintaan timeout. Coba lagi nanti.',
      };
    } catch (e, stacktrace) {
      print('❌ Caught exception: $e');
      print('🧩 Stacktrace: $stacktrace');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }
}
