import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ✅ Tambahkan ini jika belum
import 'package:app_ekos/presentation/kosan/bloc/kosan_bloc.dart';
import 'package:app_ekos/presentation/kosan/bloc/kosan_event.dart';
import 'package:app_ekos/data/model/kosan/kosan_create_request.dart';

class KosanFormScreen extends StatefulWidget {
  const KosanFormScreen({super.key});

  @override
  State<KosanFormScreen> createState() => _KosanFormScreenState();
}

class _KosanFormScreenState extends State<KosanFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Ambil dari Kamera'),
            onTap: () async {
              final picked = await picker.pickImage(source: ImageSource.camera);
              if (picked != null) {
                setState(() {
                  _selectedImages.add(File(picked.path));
                });
              }
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Pilih dari Galeri'),
            onTap: () async {
              final pickedFiles = await picker.pickMultiImage();
              if (pickedFiles.isNotEmpty) {
                setState(() {
                  _selectedImages.addAll(pickedFiles.map((e) => File(e.path)));
                });
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_latitudeController.text.isEmpty ||
          _longitudeController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Silakan pilih lokasi terlebih dahulu")),
        );
        return;
      }

      final request = KosanCreateRequest(
        nama: _namaController.text,
        alamat: _alamatController.text,
        deskripsi: _deskripsiController.text,
        latitude: _latitudeController.text,
        longitude: _longitudeController.text,
        images: _selectedImages,
      );

      context.read<KosanBloc>().add(CreateKosan(request));

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Mengirim data kosan...")));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kosan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(
                  _latitudeController.text.isNotEmpty &&
                          _longitudeController.text.isNotEmpty
                      ? 'Lat: ${_latitudeController.text}, Lng: ${_longitudeController.text}'
                      : 'Pilih lokasi di peta',
                ),
                leading: const Icon(Icons.location_on),
                trailing: const Icon(Icons.map),
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/select-location',
                  );
                  if (result != null && result is Map) {
                    setState(() {
                      _latitudeController.text = result['latitude'].toString();
                      _longitudeController.text = result['longitude']
                          .toString();

                      _alamatController.text =
                          result['address'] ?? _alamatController.text;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.photo_library),
                label: const Text('Pilih Gambar'),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _selectedImages.map((file) {
                  return Image.file(
                    file,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
