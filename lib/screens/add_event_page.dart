import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/event_service.dart';
import 'package:intl/intl.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({Key? key}) : super(key: key);

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _maxAttendeesController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool isLoading = false;

  Future<void> _selectStartDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[700]!, // 🎨 Warna header datepicker
              onPrimary: Colors.white, // Warna teks header
              surface: Colors.white, // Warna background datepicker
              onSurface: Colors.black87, // Warna teks datepicker
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue[700]!,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black87,
              ),
            ),
            child: child!,
          );
        },
      );
      if (pickedTime != null) {
        setState(() {
          _startDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          _startTimeController.text = DateFormat('HH:mm:ss').format(
            DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute),
          );
        });
      }
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[700]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue[700]!,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black87,
              ),
            ),
            child: child!,
          );
        },
      );
      if (pickedTime != null) {
        setState(() {
          _endDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          _endTimeController.text = DateFormat('HH:mm:ss').format(
            DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute),
          );
        });
      }
    }
  }

  Future<void> submitEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token tidak ditemukan, silakan login ulang')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final String startDate = '${_startDateController.text} ${_startTimeController.text}';
    final String endDate = '${_endDateController.text} ${_endTimeController.text}';

    final body = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'location': _locationController.text,
      'start_date': startDate,
      'end_date': endDate,
      'price': _priceController.text,
      'max_attendees': _maxAttendeesController.text,
      'category': _categoryController.text,
    };

    final success = await EventService.createEvent(body, token);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event berhasil ditambahkan')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan event. Silakan coba lagi.')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _startTimeController.dispose();
    _endDateController.dispose();
    _endTimeController.dispose();
    _locationController.dispose();
    _maxAttendeesController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // 🎨 Background biru sangat muda
      appBar: AppBar(
        title: const Text(
          'Tambah Event',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextFormField(
                controller: _titleController,
                labelText: 'Nama Event',
              ),
              _buildTextFormField(
                controller: _descriptionController,
                labelText: 'Deskripsi',
                maxLines: 3,
              ),
              _buildTextFormField(
                controller: _startDateController,
                labelText: 'Tanggal & Waktu Mulai',
                readOnly: true,
                onTap: _selectStartDate,
                suffixIcon: Icons.calendar_today,
              ),
              _buildTextFormField(
                controller: _endDateController,
                labelText: 'Tanggal & Waktu Selesai',
                readOnly: true,
                onTap: _selectEndDate,
                suffixIcon: Icons.calendar_today,
              ),
              _buildTextFormField(
                controller: _locationController,
                labelText: 'Lokasi',
              ),
              _buildTextFormField(
                controller: _maxAttendeesController,
                labelText: 'Max Peserta',
                keyboardType: TextInputType.number,
              ),
              _buildTextFormField(
                controller: _priceController,
                labelText: 'Harga',
                keyboardType: TextInputType.number,
              ),
              _buildTextFormField(
                controller: _categoryController,
                labelText: 'Kategori',
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue[700], // 🎨 Warna tombol diubah ke biru
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading ? null : submitEvent,
                  child: isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Tambah Event',
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
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? suffixIcon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.grey[600]),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[700]!, width: 2.0),
          ),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: Colors.blue[700])
              : null,
          filled: true,
          fillColor: Colors.grey[50],
        ),
        validator: (value) => value!.isEmpty ? '$labelText wajib diisi' : null,
      ),
    );
  }
}