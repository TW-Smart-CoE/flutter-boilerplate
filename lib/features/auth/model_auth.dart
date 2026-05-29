import 'package:json_annotation/json_annotation.dart';

part 'model_auth.g.dart';

@JsonSerializable()
class AuthRequest {
  final String username;
  final String password;

  const AuthRequest({required this.username, required this.password});

  factory AuthRequest.fromJson(Map<String, dynamic> json) => _$AuthRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AuthRequestToJson(this);
}

@JsonSerializable()
class AuthResponse {
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? json;
  final String? url;

  const AuthResponse({this.data, this.json, this.url});

  /// postman-echo echoes the request body in `data` field.
  /// We simulate token extraction from the response.
  String get token => 'fake_token_${data?['username'] ?? 'unknown'}';

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
