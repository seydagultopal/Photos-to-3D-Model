import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'project_add_screen.dart';

class MenuScreen extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;

  MenuScreen({required this.onThemeChanged});

  void _changeTheme(BuildContext context, ThemeMode themeMode) {
    onThemeChanged(themeMode);
    Navigator.of(context).pop(); // Close the dialog
  }

  void _onTabTapped(BuildContext context, int index) {
    Widget screen;
    switch (index) {
      case 0:
        screen = HomeScreen(
          projects: [], // Burada HomeScreen'e uygun projeleri gönderebilirsin
          onProjectAdded: (String project) {},
          onThemeChanged: onThemeChanged,
        );
        break;
      case 1:
        screen = ProjectAddScreen(
          onProjectAdded: (String project) {},
          projects: [], // Burada ProjectAddScreen'e uygun projeleri gönderebilirsin
          onThemeChanged: onThemeChanged,
        );
        break;
      case 2:
        screen = MenuScreen(onThemeChanged: onThemeChanged);
        break;
      default:
        screen = HomeScreen(
          projects: [], // Varsayılan olarak HomeScreen'e gidiyoruz
          onProjectAdded: (String project) {},
          onThemeChanged: onThemeChanged,
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Kenar padding
        child: ListView(
          children: [
            _buildMenuButton(
                context, Icons.account_circle, 'Account', colorScheme),
            _buildMenuButton(context, Icons.brightness_6, 'Theme', colorScheme,
                isTheme: true),
            _buildMenuButton(
                context, Icons.storage, 'Storage and Data', colorScheme),
            _buildMenuButton(context, Icons.help, 'Help', colorScheme),
            _buildMenuButton(
                context, Icons.privacy_tip, 'Privacy Policy', colorScheme),
            _buildMenuButton(context, Icons.info, 'About', colorScheme),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) => _onTabTapped(context, index),
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

  Widget _buildMenuButton(BuildContext context, IconData icon, String label,
      ColorScheme colorScheme,
      {bool isTheme = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 8.0), // ListTile'lar arası padding
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(16.0),
        ),
        onPressed: () {
          if (isTheme) {
            _showThemeDialog(context);
          } else {
            // Diğer işlemler burada
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.onPrimary),
                SizedBox(width: 16.0),
                Text(
                  label,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios,
                color: colorScheme.onPrimary, size: 16.0),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Light Theme'),
                onTap: () => _changeTheme(context, ThemeMode.light),
              ),
              ListTile(
                title: Text('Dark Theme'),
                onTap: () => _changeTheme(context, ThemeMode.dark),
              ),
              ListTile(
                title: Text('System Default'),
                onTap: () => _changeTheme(context, ThemeMode.system),
              ),
            ],
          ),
        );
      },
    );
  }
}
