import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'camera_screen.dart';
import 'edit_image_screen.dart';

class Create3DObjectScreen extends StatefulWidget {
  final List<XFile> images;
  final Function(String) onObjectCreated;
  final List<Map<String, String>> projects;
  final Function(String) onProjectAdded;
  final Function(ThemeMode) onThemeChanged;
  final String projectName;

  Create3DObjectScreen({
    required this.images,
    required this.onObjectCreated,
    required this.projects,
    required this.onProjectAdded,
    required this.onThemeChanged,
    required this.projectName,
  });

  @override
  _Create3DObjectScreenState createState() => _Create3DObjectScreenState();
}

class _Create3DObjectScreenState extends State<Create3DObjectScreen> {
  late List<XFile> _images;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _images = widget.images;
  }

  void _editImage(XFile image) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditImageScreen(image: image)),
    );
  }

  Future<void> _navigateToCameraScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraScreen()),
    );

    if (result != null && result is List<XFile>) {
      setState(() {
        _images = result;
      });
    }
  }

  void _create3DObject() {
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add at least one image to create a 3D object.'),
        ),
      );
      return;
    }

    setState(() {
      _isCreating = true;
    });

    Future.delayed(Duration(seconds: 5), () {
      widget.onObjectCreated(widget.projectName);
      widget.projects.add({
        'name': widget.projectName,
        'date': DateTime.now().toString(),
        'details': 'Details about the project.',
      });

      Navigator.pop(context, widget.projectName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New 3D Object'),
      ),
      body: _isCreating
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16.0),
                  Text(
                    'Object is being created\nplease be patient',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : _images.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 100.0, color: Colors.grey),
                      SizedBox(height: 16.0),
                      Text(
                        'To create 3D images\nstart taking pictures of your object',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _navigateToCameraScreen,
                        child: Text('Take pictures ->'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1.0,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                        ),
                        itemCount: _images.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _images.length) {
                            return GestureDetector(
                              onTap: _navigateToCameraScreen,
                              child: Container(
                                color: Colors.grey[300],
                                child: Icon(Icons.add),
                              ),
                            );
                          }
                          return GestureDetector(
                            onTap: () => _editImage(_images[index]),
                            child: Image.file(
                              File(_images[index].path),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: _create3DObject,
                        child: Text('Create 3D Object'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
