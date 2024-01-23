import 'package:api_demo/models/post.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  Future<List<Post>?> getPosts() async {
    http.Client client = http.Client();
    
    try {
      var uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
      var response = await client.get(uri);

      if (response.statusCode == 200) {
        var json = response.body;
        return postFromJson(json);
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
