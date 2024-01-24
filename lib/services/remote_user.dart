import 'package:api_demo/models/users.dart';
import 'package:http/http.dart' as http;

class RemoteUser {
  Future<List<Users>?> getUsers() async {
    http.Client client = http.Client();
    
    try {
      var uri = Uri.parse('http://lezjoy8.mooo.com/api/users');
      var response = await client.get(uri);

      if (response.statusCode == 200) {
        var json = response.body;
        return usersFromJson(json);
      } else {
        return null; // or throw an exception
      }
    } catch (e) {
      return null; // or throw an exception
    } finally {
      client.close(); // Close the client to release resources
    }
  }
}
