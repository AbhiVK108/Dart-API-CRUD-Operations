import 'dart:convert';

import 'package:crud_operations/app/data/models/user_details_model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String baseUrl =
      'https://crudcrud.com/api/6336bfa6be1a478e80a25c5ea5204708/users';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // ============================================================
  // GET ALL USERS
  // ============================================================

  Future<List<UserDetails>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = jsonDecode(response.body);

      return decodedData
          .map((json) => UserDetails.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to get users. Status: ${response.statusCode}');
  }

  // ============================================================
  // GET SINGLE USER
  // ============================================================

  Future<UserDetails> getUserById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = jsonDecode(response.body);

      return UserDetails.fromJson(decodedData);
    }

    throw Exception('Failed to get user. Status: ${response.statusCode}');
  }

  // ============================================================
  // CREATE USER
  // ============================================================

  Future<UserDetails> createUser(UserDetails user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> decodedData = jsonDecode(response.body);

      return UserDetails.fromJson(decodedData);
    }

    throw Exception('Failed to create user. Status: ${response.statusCode}');
  }

  // ============================================================
  // UPDATE USER
  // ============================================================

  Future<void> updateUser(UserDetails user) async {
    if (user.id == null || user.id!.isEmpty) {
      throw Exception('User ID is required for update');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/${user.id}'),
      headers: headers,
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user. Status: ${response.statusCode}');
    }
  }

  // ============================================================
  // DELETE USER
  // ============================================================

  Future<void> deleteUser(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user. Status: ${response.statusCode}');
    }
  }
}
