import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Global olarak çekilen resimleri saklayan liste
List<XFile> _globalImages = [];

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _takePicture() async {
    if (_controller != null &&
        _controller!.value.isInitialized &&
        !_isTakingPicture) {
      setState(() {
        _isTakingPicture = true;
      });
      try {
        final image = await _controller!.takePicture();
        setState(() {
          _globalImages
              .add(XFile(image.path)); // Çekilen resmi global listeye ekliyoruz
        });
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          _isTakingPicture = false;
        });
      }
    }
  }

  void _finish() {
    Navigator.pop(context, _globalImages); // Global listeyi geri döndürüyoruz
  }

  Future<void> _selectFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _globalImages.add(XFile(pickedFile
            .path)); // Galeriden eklenen resmi global listeye ekliyoruz
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Camera'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          if (_isTakingPicture)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: _selectFromGallery,
            ),
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _finish,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
