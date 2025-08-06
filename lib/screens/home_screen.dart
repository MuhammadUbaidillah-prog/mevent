import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/event_service.dart';
import 'add_event_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? token;
  Future<List<dynamic>>? _eventsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');

    if (storedToken != null) {
      setState(() {
        token = storedToken;
        _eventsFuture = EventService.getEvents();
      });
    } else {
      setState(() {
        token = null;
        _eventsFuture = null;
      });
    }
  }

  void _refreshEvents() {
    if (token != null) {
      setState(() {
        _eventsFuture = EventService.getEvents();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Mevent'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshEvents,
          ),
        ],
      ),
      body: token == null
          ? const Center(child: CircularProgressIndicator())
          : _eventsFuture == null
          ? const Center(child: Text('Gagal memuat event.'))
          : Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Daftar Event',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _eventsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child:
                      Text('Error: ${snapshot.error.toString()}'));
                } else if (!snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Tidak ada event ditemukan.'));
                }

                final events = snapshot.data!;
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return ListTile(
                      leading: event['image_url'] != null &&
                          event['image_url']
                              .toString()
                              .isNotEmpty
                          ? Image.network(
                        event['image_url'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : const Icon(Icons.event),
                      title:
                      Text(event['name'] ?? 'Tanpa Nama Event'),
                      subtitle: Text(
                          '${event['date'] ?? '-'} | ${event['category'] ?? '-'}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEventPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
