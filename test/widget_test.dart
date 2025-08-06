// event_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class EventService {
  static const _baseUrl = 'http://103.160.63.165/api';

  static Future<List<dynamic>> getEvents() async {
    final uri = Uri.parse('$_baseUrl/events');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final data = json.decode(response.body);
          if (data is Map &&
              data.containsKey('data') &&
              data['data'] is Map &&
              data['data'].containsKey('events') &&
              data['data']['events'] is List) {
            return data['data']['events'];
          } else {
            return [];
          }
        } else {
          return [];
        }
      } else {
        throw Exception('Gagal memuat event. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error: $e');
      rethrow;
    }
  }

  static Future<bool> createEvent(Map<String, dynamic> eventData, String token) async {
    final uri = Uri.parse('$_baseUrl/events');
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(eventData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint('✅ Event baru berhasil ditambahkan.');
        return true;
      } else {
        debugPrint('❌ Gagal menambahkan event. Status: ${response.statusCode}');
        debugPrint('❌ Respons: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Exception saat membuat event: $e');
      return false;
    }
  }

  static Future<bool> deleteEvent(int eventId, String token) async {
    final uri = Uri.parse('$_baseUrl/events/$eventId');
    try {
      final response = await http.delete(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('✅ Event dengan ID $eventId berhasil dihapus.');
        return true;
      } else {
        debugPrint('❌ Gagal menghapus event. Status: ${response.statusCode}, Respons: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Exception saat menghapus event: $e');
      return false;
    }
  }
}