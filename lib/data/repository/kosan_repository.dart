import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../model/kosan/kosan_response.dart';
import '../model/kosan/kosan_model.dart';
import '../model/kosan/kosan_create_request.dart';
import '../../services/service_http_client.dart';

class KosanRepository {
  final ServiceHttpClient client;
  final secureStorage = FlutterSecureStorage();

  KosanRepository(this.client);

  Future<String> _getToken() async {
    final token = await secureStorage.read(key: 'token');
    if (token == null) throw Exception('Token tidak ditemukan');
    return token;
  }

  Future<List<KosanResponse>> fetchAllKosan() async {
    final response = await client.get("kosan"); // Sesuaikan endpoint jika berbeda

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data']; // Sesuaikan key jika API berbeda
      return data.map((e) => KosanResponse.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data kosan");
    }
  }

  // GET all kosans
  Future<List<KosanModel>> fetchKosans() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('${client.baseUrl}kosan'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((json) => KosanModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data kosan: ${response.body}');
    }
  }

  // POST create kosan
  Future<void> createKosan(KosanCreateRequest request) async {
    final token = await _getToken();
    final uri = Uri.parse('${client.baseUrl}kosan');

    final multipartRequest = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields.addAll(request.toMap());

    for (final file in request.images) {
      multipartRequest.files.add(
        await http.MultipartFile.fromPath(
          'images[]',
          file.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    final streamedResponse = await multipartRequest.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 201) {
      throw Exception('Gagal membuat kosan: ${response.body}');
    }
  }

  // PUT update kosan
  Future<void> updateKosan(int id, KosanCreateRequest request) async {
    final token = await _getToken();
    final uri = Uri.parse('${client.baseUrl}kosan/$id');

    final multipartRequest = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['_method'] = 'PUT'
      ..fields.addAll(request.toMap());

    for (final file in request.images) {
      multipartRequest.files.add(
        await http.MultipartFile.fromPath(
          'images[]',
          file.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    final streamedResponse = await multipartRequest.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui kosan: ${response.body}');
    }
  }

  // DELETE kosan
  Future<void> deleteKosan(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('${client.baseUrl}kosan/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus kosan: ${response.body}');
    }
  }
}
