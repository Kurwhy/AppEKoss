import 'dart:convert';

import 'package:app_ekos/data/model/request/auth/login_request_model.dart';
import 'package:app_ekos/data/model/request/auth/register_request_model.dart';
import 'package:app_ekos/data/model/response/auth_response_model.dart';
import 'package:app_ekos/services/service_http_client.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final ServiceHttpClient _serviceHttpClient;
  final sercureStorage = FlutterSecureStorage();

  AuthRepository(this._serviceHttpClient);

  Future<Either<String, AuthResponseModel>> login(
    LoginRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.post(
        "login",
        requestModel.toMap(),
      );
      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final loginResponse = AuthResponseModel.fromMap(jsonResponse);
        await sercureStorage.write(
          key: "authToken",
          value: loginResponse.data?.token ?? '',
        );
        await sercureStorage.write(
          key: "userRole",
          value: loginResponse.data?.role ?? '',
        );

        return Right(loginResponse);
      } else {
        return Left(jsonResponse['message'] ?? "Login failed");
      }
    } catch (e) {
      return Left("An error occured white logging in.");
    }
  }

  Future<Either<String, String>> register(
    RegisterRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.post(
        "register",
        requestModel.toMap(),
      );
      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 201) {
        final registerResponse = jsonResponse['message'] as String;
        return Right(registerResponse);
      } else {
        return Left(jsonResponse['message'] ?? "Registration failed");
      }
    } catch (e) {
      return Left("An error occurred while registering.");
    }
  }
}
