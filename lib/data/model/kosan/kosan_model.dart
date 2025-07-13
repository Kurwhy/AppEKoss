class KosanModel {
  final int id;
  final String nama;
  final String alamat;
  final String deskripsi;
  final String latitude;
  final String longitude;
  final List<String> images;

  KosanModel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.deskripsi,
    required this.latitude,
    required this.longitude,
    required this.images,
  });

  factory KosanModel.fromJson(Map<String, dynamic> json) {
    return KosanModel(
      id: json['id'],
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      images: (json['images'] as List<dynamic>? ?? [])
          .map<String>((img) => img['url'].toString())
          .toList(),
    );
  }
}
