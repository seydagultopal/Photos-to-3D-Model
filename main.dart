import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/project_add_screen.dart';
import 'theme_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Map<String, String>> projects = [];

  void _addProject(String name) {
    final now = DateTime.now();
    final formattedDate =
        "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}";
    setState(() {
      projects.add({
        'name': name,
        'date': formattedDate,
        'details': 'project details',
      });
    });
  }

  void _changeTheme(ThemeMode themeMode) {
    Provider.of<ThemeNotifier>(context, listen: false).setThemeMode(themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeNotifier.themeMode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: HomeScreen(
            projects: projects,
            onProjectAdded: _addProject,
            onThemeChanged: _changeTheme,
          ),
          routes: {
            '/home': (context) => HomeScreen(
                  projects: projects,
                  onProjectAdded: _addProject,
                  onThemeChanged: _changeTheme,
                ),
            '/add': (context) => ProjectAddScreen(
                  onProjectAdded: _addProject,
                  projects: projects,
                  onThemeChanged: _changeTheme,
                ),
            '/menu': (context) => MenuScreen(
                  onThemeChanged: _changeTheme,
                ),
          },
        );
      },
    );
  }
}
