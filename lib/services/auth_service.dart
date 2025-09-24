import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // final String baseUrl = 'http://10.0.2.2:3000/api/auth';
  final String baseUrl = 'http://localhost:3000/api/auth';
 // Android emulator
  // For real device, replace with your PC IP

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String campusId,
    required String userType,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'campusId': campusId,
        'userType': userType,
        'password': password,
      }),
    );
    if (response.statusCode == 201) return jsonDecode(response.body);
    throw Exception(jsonDecode(response.body)['message']);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception(jsonDecode(response.body)['message']);
  }

  Future<Map<String, dynamic>> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) return jsonDecode(response.body)['data'];
    throw Exception(jsonDecode(response.body)['message']);
  }
}
