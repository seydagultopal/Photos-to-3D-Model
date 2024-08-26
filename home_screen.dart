import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'menu_screen.dart';
import 'project_add_screen.dart';
import 'project_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<Map<String, String>> projects;
  final Function(String) onProjectAdded;
  final Function(ThemeMode) onThemeChanged;

  HomeScreen({
    Key? key,
    required this.projects,
    required this.onProjectAdded,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _searchQuery = "";
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _sortOrder = "name";

  void _onTabTapped(int index) {
    if (_currentIndex == index) return;

    setState(() {
      _currentIndex = index;
    });

    Widget screen;
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

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _searchQuery = "";
    });
  }

  void _sortProjects(String criteria) {
    setState(() {
      _sortOrder = criteria;
      if (_sortOrder == "name") {
        widget.projects.sort((a, b) => a['name']!.compareTo(b['name']!));
      } else if (_sortOrder == "date") {
        widget.projects.sort((a, b) => a['date']!.compareTo(b['date']!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> _filteredProjects =
        widget.projects.where((project) {
      return project['name']!
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();

    // Temaya göre doğru logoyu seç
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String logoPath = isDarkMode
        ? 'assets/images/daisynth-logo-dark.svg'
        : 'assets/images/daisynth-logo-light.svg';

    // MenuScreen'deki renkleri buraya uyguluyoruz
    final colorScheme = Theme.of(context).colorScheme;
    final Color helloMaryBackgroundColor = colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Project...',
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              )
            : SvgPicture.asset(
                logoPath,
                height: 24, // Logonun boyutunu buradan ayarlıyoruz
                fit: BoxFit.contain,
              ),
        leading: _isSearching
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _stopSearch,
              )
            : null,
        actions: [
          _isSearching
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: _stopSearch,
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _startSearch,
                ),
          PopupMenuButton<String>(
            icon: Icon(Icons.sort),
            onSelected: _sortProjects,
            itemBuilder: (BuildContext context) {
              return {'Name', 'Date'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice.toLowerCase(),
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: helloMaryBackgroundColor, // Menüdeki renklerle aynı
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                    SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HELLO, MARY',
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'info@info.com',
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Project History',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _filteredProjects.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectDetailScreen(
                            project: _filteredProjects[index],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _filteredProjects[index]['name']!,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              _filteredProjects[index]['date']!,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              _filteredProjects[index]['details']!,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0 ? Colors.blue : Colors.grey,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
              color: _currentIndex == 1 ? Colors.blue : Colors.grey,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
              color: _currentIndex == 2 ? Colors.blue : Colors.grey,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
