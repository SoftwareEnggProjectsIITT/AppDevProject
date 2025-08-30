import 'package:flutter/material.dart';
import 'package:frontend/data/notifiers.dart';
import 'package:frontend/views/pages/bookmarks_page.dart';
import 'package:frontend/views/pages/chatbot_page.dart';
import 'package:frontend/views/pages/home_page.dart';
import 'package:frontend/views/widgets/bottom_navbar.dart';

List<Widget> pages = [const HomePage(), const ChatbotPage(), const BookmarksPage()];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () {
              isDarkModeNotifier.value = !isDarkModeNotifier.value;
            },
            icon: ValueListenableBuilder(
              valueListenable: isDarkModeNotifier,
              builder: (context, isDarkMode, child) {
                return Icon(isDarkMode ? Icons.light_mode :Icons.dark_mode);
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('menu')),
            ListTile(
              title: Text('Item 1'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: selectedPageNotifier,
          builder: (context, selectedPage, child) {
            return pages.elementAt(selectedPage);
          },
        ),
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
