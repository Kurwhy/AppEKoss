import 'package:flutter/material.dart';
import 'package:app_ekos/data/model/kosan/kosan_model.dart'; 

class KosanDetailScreen extends StatelessWidget {
  final KosanModel kosan;

  const KosanDetailScreen({super.key, required this.kosan});

  @override
  Widget build(BuildContext context) {
    final imageUrl = kosan.images.isNotEmpty ? kosan.images.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kosan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          imageUrl != null
              ? Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 48),
                ),
          const SizedBox(height: 16),
          Text(
            kosan.nama,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(kosan.alamat),
          const SizedBox(height: 8),
          Text('Deskripsi: ${kosan.deskripsi}'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}