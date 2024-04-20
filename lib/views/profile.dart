import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final _profileBox = Hive.box('profile');

  @override
  void initState() {
    super.initState();

    // _nameController.text = _profileBox.get('name') ?? '';
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _profileBox.put('name', _nameController.text);
      _profileBox.put('email', _emailController.text);
      if (_image != null) {
        _profileBox.put('image', _image!.readAsBytesSync());
      }
    }
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Set Profile',
          textScaler: TextScaler.linear(1.4),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 80.0,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : (_profileBox.get('image') != null
                        ? Image.memory(_profileBox.get('image') as Uint8List)
                            .image
                        : null),
                child: _image == null && _profileBox.get('image') == null
                    ? const Icon(Icons.camera_alt, size: 60.0)
                    : null,
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: TextFormField(
                textAlign: TextAlign.center,
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 0),
                      borderRadius: BorderRadius.circular(20)),
                  // labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextFormField(
              textAlign: TextAlign.center,
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 0),
                    borderRadius: BorderRadius.circular(20)),
                // labelText: 'Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: 40.0),
            FilledButton(
              style: const ButtonStyle(
                  elevation: MaterialStatePropertyAll(10),
                  padding: MaterialStatePropertyAll(EdgeInsets.all(16))),
              onPressed: _saveProfile,
              child: const Text('Save Profile'),
            ),
            FilledButton(
              style: const ButtonStyle(elevation: MaterialStatePropertyAll(10)),
              child: const Text("Skip for Later"),
              onPressed: () {
                context.go('/home');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
