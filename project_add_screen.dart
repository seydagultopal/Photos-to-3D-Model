import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'create_3d_object_screen.dart';
import 'home_screen.dart';
import 'menu_screen.dart';

class ProjectAddScreen extends StatefulWidget {
  final Function(String) onProjectAdded;
  final Function(ThemeMode) onThemeChanged;
  final List<Map<String, String>> projects;

  ProjectAddScreen({
    Key? key,
    required this.onProjectAdded,
    required this.onThemeChanged,
    required this.projects,
  }) : super(key: key);

  @override
  _ProjectAddScreenState createState() => _ProjectAddScreenState();
}

class _ProjectAddScreenState extends State<ProjectAddScreen> {
  int _currentIndex = 1; // Bu sayfa varsayılan olarak ikinci sekmede olacak

  void _onTabTapped(int index) {
    if (_currentIndex == index) return;

    setState(() {
      _currentIndex = index;
    });

    late Widget screen; // Değişkeni burada tanımlayıp sonra atıyoruz

    switch (index) {
      case 0:
        screen = HomeScreen(
          projects: widget.projects,
          onProjectAdded: widget.onProjectAdded,
          onThemeChanged: widget.onThemeChanged,
        );
        break;
      case 1:
        screen = ProjectAddScreen(
          onProjectAdded: widget.onProjectAdded,
          projects: widget.projects,
          onThemeChanged: widget.onThemeChanged,
        );
        break;
      case 2:
        screen = MenuScreen(onThemeChanged: widget.onThemeChanged);
        break;
      default:
        screen = HomeScreen(
          projects: widget.projects,
          onProjectAdded: widget.onProjectAdded,
          onThemeChanged: widget.onThemeChanged,
        );
        break;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => screen,
        transitionDuration: Duration(milliseconds: 300),
        transitionsBuilder: (context, animation1, animation2, child) {
          return FadeTransition(
            opacity: animation1,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Project'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _projectNameController,
              decoration: InputDecoration(
                labelText: 'Project Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Dataset Type',
                border: OutlineInputBorder(),
              ),
              value: _selectedDatasetType,
              items: <String>['Type 1', 'Type 2', 'Type 3'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedDatasetType = newValue;
                });
              },
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Objects',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedObject,
                    items: _createdObjects.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedObject = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _navigateToCreate3DObjectScreen,
                  child: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: _generateProject,
                child: Text('Generate'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '',
          ),
        ],
      ),
    );
  }

  final TextEditingController _projectNameController = TextEditingController();
  String? _selectedDatasetType;
  String? _selectedObject;
  List<XFile> _images = [];
  List<String> _createdObjects = [];

  void _generateProject() {
    final projectName = _projectNameController.text;
    if (projectName.isEmpty ||
        _selectedDatasetType == null ||
        _selectedObject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }
    widget.onProjectAdded(projectName);
    Navigator.pop(context); // Proje eklendikten sonra bir önceki ekrana dön
  }

  void _addObject(String newObject) {
    setState(() {
      if (!_createdObjects.contains(newObject)) {
        _createdObjects.add(newObject);
      }
      _selectedObject = newObject;
    });
  }

  Future<void> _navigateToCreate3DObjectScreen() async {
    if (_projectNameController.text.isEmpty || _selectedDatasetType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please fill out all fields before proceeding.')),
      );
      return;
    }

    final newObject = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Create3DObjectScreen(
          images: _images,
          onObjectCreated: _addObject,
          projects: widget.projects,
          onProjectAdded: widget.onProjectAdded,
          onThemeChanged: widget.onThemeChanged,
          projectName: _projectNameController.text,
        ),
      ),
    );

    if (newObject != null && newObject is String) {
      _addObject(newObject);
    }
  }
}
