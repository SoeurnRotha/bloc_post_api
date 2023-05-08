import 'dart:convert';

import 'package:get_and_pos/model/user_model.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  static const String baseUrl = "https://jsonplaceholder.typicode.com/posts";
  Future<List<User>> getAllUser() async {
    var client = http.Client();
    var uri = Uri.parse(baseUrl);
    var res = await client.get(uri);

    if (res.statusCode == 200) {
      var json = res.body;
      return userFromJson(json);
    } else {
      throw Exception('Error');
    }
  }

  //add user
  Future<User> postUser(String title, String body) async {
    final uri = Uri.parse(baseUrl);
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'body': body}),
    );
    if (res.statusCode == 201) {
      print('Post successful');
      var json = res.body;
      print('JSON response: $json');
      if (json != null) {
        var user = User.fromJson(jsonDecode(json));
        print('User created: $user');
        return user;
      } else {
        throw Exception('Response from server is null');
      }
    } else {
      print('Failed to post');
      throw Exception('Error');
    }
  }

  Future<User> updateUser(int id, String title, String body) async {
    final uri = Uri.parse('${baseUrl}/$id');
    final res = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'body': body,
      }),
    );
    if (res.statusCode == 200) {
      print('Post updated successfully');
      var json = res.body;
      return User.fromJson(jsonDecode(json));
    } else {
      print('Failed to update post. Error: ${res.reasonPhrase}');
      throw Exception('Error');
    }
  }

  Future<bool> deleteUser(int id) async {
    final uri = Uri.parse('${baseUrl}/$id');
    final res = await http.delete(uri);
    if (res.statusCode == 200) {
      print('Delete successful ${id}');
      return true;
    } else {
      print('Delete filed');
      return false;
    }
  }
}
