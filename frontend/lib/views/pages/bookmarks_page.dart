import 'package:flutter/material.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 200,
            color: Colors.red,
            child: const Center(
              child: Text(
                'Bookmarks Page',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            color: Colors.purple,
            child: const Center(
              child: Text(
                'Your Bookmarked Items',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            color: Colors.teal,
            child: const Center(
              child: Text(
                'Manage your bookmarks here!',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ],
      )
    );
  }
}
