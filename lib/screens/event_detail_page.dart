// event_detail_page.dart
import 'package:flutter/material.dart';

class EventDetailPage extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ambil data event
    final title = event['title'] ?? 'N/A';
    final description = event['description'] ?? 'Tidak ada deskripsi.';
    final location = event['location'] ?? 'N/A';
    final startDate = event['start_date'] ?? 'N/A';
    // Anda bisa menambahkan detail lain seperti creator, price, dll.

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(description),
            const SizedBox(height: 16),
            const Text(
              'Lokasi:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(location),
            const SizedBox(height: 16),
            const Text(
              'Tanggal Mulai:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(startDate),
            // Tambahkan widget lain untuk menampilkan informasi detail
          ],
        ),
      ),
    );
  }
}