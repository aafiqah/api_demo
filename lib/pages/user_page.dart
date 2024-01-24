import 'package:api_demo/models/users.dart';
import 'package:api_demo/services/remote_user.dart';
import 'package:flutter/material.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({Key? key}) : super(key: key);

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  List<Users>? users;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    // Fetch data from API
    getData();
  }

  Future<void> getData() async {
    final fetchedUsers = await RemoteUser().getUsers();
    if (fetchedUsers != null) {
      setState(() {
        users = fetchedUsers;
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: isLoaded
          ? (users != null && users!.isNotEmpty)
              ? ListView.builder(
                  itemCount: users!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.network(
                              users![index].profilePic,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  users![index].username,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height:3),
                                Text(
                                  users![index].email,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : const Center(child: Text('No users available'))
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
