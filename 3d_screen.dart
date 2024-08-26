import 'package:flutter/material.dart';

class ThreeDScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pop(context);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('3D Screen'),
      ),
      body: Center(
        child: Text('this screen is for 3d model'),
      ),
    );
  }
}
