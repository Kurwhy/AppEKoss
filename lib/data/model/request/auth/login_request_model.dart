import 'dart:convert';

class LoginRequestModel {
  final String? email;
  final String? password;

  LoginRequestModel({
    this.email,
    this.password,
  });

  factory LoginRequestModel.fromJson(String str) => LoginRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginRequestModel.fromMap(Map<String, dynamic> json) 
    => LoginRequestModel(
      email: json['email'] as String?,
      password: json['password'] as String?,
    );
  

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}