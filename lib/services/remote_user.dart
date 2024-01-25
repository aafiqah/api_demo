import 'dart:convert';

import 'package:api_demo/models/users.dart';
import 'package:http/http.dart' as http;

class RemoteUser {
  static const String baseUrl = "http://lezjoy8.mooo.com/api/users";

  // Fetch a list of users
  Future<List<Users>?> getUsers() async {
    http.Client client = http.Client();

    try {
      var uri = Uri.parse(baseUrl);
      var response = await client.get(uri);

      if (response.statusCode == 200) {
        var json = response.body;
        return usersFromJson(json);
      } else {
        throw Exception('Failed to load users. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    } finally {
      client.close(); // Close the client to release resources
    }
  }

  // Get a single user by ID
  Future<Users?> getUserById(String id) async {
    http.Client client = http.Client();
    String url = "$baseUrl/$id";

    try {
      var uri = Uri.parse(url);
      var response = await client.get(uri);

      if (response.statusCode == 200) {
        var json = response.body;
        var userList = usersFromJson(json);
        if (userList.isNotEmpty) {
          return userList.first;
        } else {
          throw Exception('User not found');
        }
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else {
        throw Exception('Failed to get user. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get user: $e');
    } finally {
      client.close(); // Close the client to release resources
    }
  }

  // Create a new user
  Future<Users> createUser(Users user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: json.encode(user.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return Users.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user. Status Code: ${response.statusCode}');
    }
  }
  
  // Update a user by ID
  Future<Users> updateUser(String id, Users user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      body: json.encode(user.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Users.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user. Status Code: ${response.statusCode}');
    }
  }

  // Delete a user by ID
  Future<void> deleteUser(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user. Status Code: ${response.statusCode}');
    }
  }

}
