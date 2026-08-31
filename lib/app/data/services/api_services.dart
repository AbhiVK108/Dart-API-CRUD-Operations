import 'dart:convert';

import 'package:crud_operations/app/data/models/user_details_model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String baseUrl =
      'https://crudcrud.com/api/372974ec2aeb48769f793dfb2aa7ec7b/users';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  
  // ============================================================
  // GET ALL USERS
  // ============================================================

  Future<List<UserDetails>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl), headers: headers);

//Success
    if (response.statusCode == 200) {
      final List<dynamic> decodedData = jsonDecode(response.body);

      return decodedData
          .map((json) => UserDetails.fromJson(json as Map<String, dynamic>))
          .toList();

         
    }

    //Error

    throw Exception('Failed to get users. Status: ${response.statusCode}');
  }



  // ============================================================
  // CREATE USER
  // ============================================================

  Future<UserDetails> createUser(UserDetails user) async {
    final response = await http.post(
      Uri.parse(baseUrl), //uri
      headers: headers, //header
      body: jsonEncode(user.toJson()), //data
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
