import 'dart:io';

import 'package:api_demo/models/users.dart';
import 'package:api_demo/pages/add_edit_page.dart';
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

  final RemoteUser _remoteUser = RemoteUser();
  Future<void> deleteUser(String id) async {
    try {
      await _remoteUser.deleteUser(id);
      getData(); // Refresh the data after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'User deleted successfully',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to delete user',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: buildFloatingButton(),
    );
  }

  Widget buildBody() {
    return isLoaded
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
                          child: users![index].profile_pic.isNotEmpty
                            ? Uri.parse(users![index].profile_pic).isAbsolute
                              ? Image.network(
                                  users![index].profile_pic,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(users![index].profile_pic),
                                  fit: BoxFit.cover,
                                )
                            : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.blue[300],
                              ),
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
                              const SizedBox(height: 3),
                              Text(
                                users![index].email,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deleteUser(users![index].id);
                          },
                        ),
                        const SizedBox(width: 3),
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => AddEditPage(
                                users: users![index],
                              ),
                            ));
                            refreshUserPage();
                          },
                        ),
                      ],
                    ),
                  );
                },
              )
            : const Center(child: Text('No users available'))
        : const Center(child: CircularProgressIndicator());
  }

  void refreshUserPage() async {
    getData();   
  }

  FloatingActionButton buildFloatingButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const AddEditPage(),
        ));
        refreshUserPage();
      },
      backgroundColor: Colors.blueAccent,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text(
        'Users API',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      backgroundColor: Colors.blueAccent,
      centerTitle: true,
    );
  }
}
