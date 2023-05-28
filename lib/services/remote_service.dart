import 'package:riseup_task/model/usersmodel.dart';
import 'package:http/http.dart' as http;
class RemoteService {
  Future<List<User>?> getUsers() async {
    try {
      var client = http.Client();
      var uri = Uri.parse('https://gorest.co.in/public/v2/users');
      var response = await client.get(uri);

      if (response.statusCode == 200) {
        var json = response.body;
        return userFromJson(json);
      } else {
        throw Exception('Failed to fetch users');
      }
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  Future<void> addUser(User user) async {
    var client = http.Client();

    var uri = Uri.parse('https://gorest.co.in/public/v2/users');
    var response = await client.post(
      uri,
      body: userToJson([user]), // Convert single user to a list
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      print('User added successfully!');
    } else {
      print('Failed to add user');
    }
  }

  Future<void> editUser(User user) async {
    var client = http.Client();

    var uri = Uri.parse('https://gorest.co.in/public/v2/users/${user.id}');
    var response = await client.put(
      uri,
      body: userToJson([user]), // Convert single user to a list
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('User edited successfully!');
    } else {
      print('Failed to edit user');
    }
  }

  Future<void> deleteUser(int userId) async {
    var client = http.Client();

    var uri = Uri.parse('https://gorest.co.in/public/v2/users/$userId');
    var response = await client.delete(uri);

    if (response.statusCode == 204) {
      print('User deleted successfully!');
    } else {
      print('Failed to delete user');
    }
  }
}
