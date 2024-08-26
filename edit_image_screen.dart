import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditImageScreen extends StatefulWidget {
  final XFile image;

  EditImageScreen({required this.image});

  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {
  late File _imageFile;

  @override
  void initState() {
    super.initState();
    _imageFile = File(widget.image.path);
  }

  void _retakePicture() {
    Navigator.pop(context, 'retake');
  }

  void _deleteImage() {
    Navigator.pop(context, 'delete');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Image'),
      ),
      body: Center(
        child: Image.file(_imageFile),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.undo),
              onPressed: _retakePicture,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteImage,
            ),
          ],
        ),
      ),
    );
  }
}
