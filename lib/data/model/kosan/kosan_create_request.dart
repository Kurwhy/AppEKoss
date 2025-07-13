import 'dart:io';

class KosanCreateRequest {
  final String nama;
  final String alamat;
  final String deskripsi;
  final String latitude;
  final String longitude;
  final List<File> images;

  KosanCreateRequest({
    required this.nama,
    required this.alamat,
    required this.deskripsi,
    required this.latitude,
    required this.longitude,
    required this.images,
  });

  Map<String, String> toMap() {
    return {
      'nama': nama,
      'alamat': alamat,
      'deskripsi': deskripsi,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
