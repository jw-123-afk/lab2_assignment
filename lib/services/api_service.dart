import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/worker.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.68.50/workers';

  Future<Map<String, dynamic>> registerWorker({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register_worker.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'password': password,
        'phone': phone,
        'address': address,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to register worker');
    }
  }

  Future<Worker> loginWorker({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login_worker.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Worker.fromJson(data['worker']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to login');
    }
  }
}
