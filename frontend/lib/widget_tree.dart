import 'package:flutter/material.dart';
import 'package:frontend/providers/notifiers.dart';
import 'package:frontend/screens/bookmarks_page.dart';
import 'package:frontend/screens/chatbot_page.dart';
import 'package:frontend/screens/home_page.dart';
import 'package:frontend/widgets/bottom_navbar.dart';
import 'package:frontend/widgets/main_drawer.dart';

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
      drawer: MainDrawer(),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
