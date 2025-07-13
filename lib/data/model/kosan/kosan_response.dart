class KosanResponse {
  final int id;
  final String nama;
  final String alamat;
  final String? deskripsi;
  final String? latitude;
  final String? longitude;
  final List<String> images;

  KosanResponse({
    required this.id,
    required this.nama,
    required this.alamat,
    this.deskripsi,
    this.latitude,
    this.longitude,
    required this.images,
  });

  factory KosanResponse.fromJson(Map<String, dynamic> json) {
    return KosanResponse(
      id: json['id'],
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      deskripsi: json['deskripsi'],
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'deskripsi': deskripsi,
      'latitude': latitude,
      'longitude': longitude,
      'images': images,
    };
  }
}
