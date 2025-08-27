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
