import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/post_data.dart';
import 'package:frontend/providers/bookmarks_provider.dart';
import 'package:frontend/widgets/post_card.dart';

class BookmarksPage extends ConsumerWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<PostData> bookmarks = ref.watch(bookmarksProvider);

    return Scaffold(
      body: bookmarks.isEmpty
      ? const Center(
        child: Text(
          "No bookmarks yet",
          style: TextStyle(fontSize: 16),
        ),
      )
      : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: bookmarks.length,
        itemBuilder: (context, index) {
          final post = bookmarks[index];
          return PostCard(post: post, needLike: false); // Uses your existing PostCard
        },
      ),
    );
  }
}

