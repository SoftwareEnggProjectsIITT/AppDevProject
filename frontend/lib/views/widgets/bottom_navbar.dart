import 'package:flutter/material.dart';
import 'package:frontend/data/notifiers.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_rounded),
              label: 'Chatbot',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmarks),
              label: 'Bookmarks',
            ),
          ],
          onDestinationSelected: (int index) {
            selectedPageNotifier.value = index;
          },
          selectedIndex: selectedPage,
        );
      }
    );
  }
}
