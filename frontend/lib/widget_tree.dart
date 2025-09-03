import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        // Use ValueListenableBuilder so AppBar actions update when selectedPageNotifier changes
        actions: [
          ValueListenableBuilder<int>(
            valueListenable: selectedPageNotifier,
            builder: (context, selectedPage, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selectedPage == 1)
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                    ),
                  Consumer(
                    builder: (context, ref, _) {
                      final isDarkMode = ref.watch(darkModeProvider);
                      return IconButton(
                        icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                        onPressed: () {
                          ref.read(darkModeProvider.notifier).toggleTheme();
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: ValueListenableBuilder<int>(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return IndexedStack(
            index: selectedPage,
            children: pages,
          );
        },
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
