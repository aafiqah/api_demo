import 'dart:io';

import 'package:api_demo/models/users.dart';
import 'package:api_demo/services/remote_user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEditPage extends StatefulWidget {
  const AddEditPage({Key? key, this.users}) : super(key: key);

  final Users? users;

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _profilePicController = TextEditingController();

  File? _image;

  @override
  void initState() {
    super.initState();
    if (widget.users != null) {
      _usernameController.text = widget.users!.username;
      _emailController.text = widget.users!.email;
      _profilePicController.text = widget.users!.profile_pic;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _profilePicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: _buildAvatar(),
              ),
              const SizedBox(height: 30),
              _buildTextField(_usernameController, 'Username'),
              const SizedBox(height: 30),
              _buildTextField(_emailController, 'Email Address'),
              const SizedBox(height: 30),
              _buildElevatedButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Future _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
        _profilePicController.text = image.path;
      });
    }
  }

  Widget _buildAvatar() {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF32BAA5),
                width: 5.0,
              ),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: _image != null
                  ? ClipOval(
                      child: Image.file(
                        _image!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  : _profilePicController.text.isNotEmpty
                      ? ClipOval(
                          child: _isNetworkImage()
                              ? Image.network(
                                  _profilePicController.text,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(_profilePicController.text),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                        )
                      : const Icon(Icons.camera_alt),
            ),
          ),
          Positioned(
            bottom: 6,
            right: 2,
            child: Container(
              width: 30.0,
              height: 30.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF32BAA5),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 15.0,
                ),
                onPressed: _pickImage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isNetworkImage() {
  if (_profilePicController.text.startsWith('http') ||
      _profilePicController.text.startsWith('https')) {
    return true; // It's a network image
  } else {
    return false; // It's a local file path
  }
}

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: const TextStyle(
          color: Colors.grey, // color for the label when not focused
        ),
        floatingLabelStyle: const TextStyle(
          color: Color(0xFF32BAA5), // color for the label when focused
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: Color(0xFF32BAA5),
          ),
        ),
      ),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildElevatedButton(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          if (widget.users != null) {
            await RemoteUser().updateUser(
                widget.users!.id,
                Users(
                  id: widget.users!.id,
                  username: _usernameController.text,
                  email: _emailController.text,
                  profile_pic: _profilePicController.text,
                ));
            Navigator.of(context).pop(true);
          }
          // to create new mycontact to local storage
          else {
            await RemoteUser().createUser(Users(
              id: '',
              username: _usernameController.text,
              email: _emailController.text,
              profile_pic: _profilePicController.text,
            ));
            Navigator.of(context).pop(true);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF32BAA5),
          padding: const EdgeInsets.all(15),
        ),
        child: const Text(
          'Done',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w500,
            height: 0.09,
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(false),
      ),
    );
  }
}
