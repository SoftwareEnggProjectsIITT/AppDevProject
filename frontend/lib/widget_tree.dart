import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/notifiers.dart';
import 'package:frontend/screens/all_chats.dart';
import 'package:frontend/screens/bookmarks_page.dart';
import 'package:frontend/screens/home_page.dart';
import 'package:frontend/widgets/bottom_navbar.dart';
import 'package:frontend/widgets/main_drawer.dart';
import 'package:frontend/widgets/new_chat.dart';


List<Widget> pages = [const HomePage(), const AllChatsScreen(), const BookmarksPage()];
List<String> pageTitles = ['Explore Posts', 'LegalEase Chatbots', 'Bookmarks'];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  void showAddChatScreen() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewChat()
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return Scaffold(
          appBar: AppBar(
            title: FittedBox(
              child: Text(
                pageTitles[selectedPage], 
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                    // Theme.of(context).colorScheme.onPrimary,
                    Theme.of(context).colorScheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selectedPage == 1)
                  IconButton(
                    onPressed: showAddChatScreen,
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
              ),
            ],
          ),
          drawer: MainDrawer(),
          body: IndexedStack(
            index: selectedPage,
            children: pages,
          ),
          bottomNavigationBar: const BottomNavbar(),
        );
      },
    ),
    );
  }
}
