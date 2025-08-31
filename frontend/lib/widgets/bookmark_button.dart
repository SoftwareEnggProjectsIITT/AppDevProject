import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/post_data.dart';
import 'package:frontend/providers/bookmarks_provider.dart';

class BookmarkButton extends ConsumerStatefulWidget {
  final PostData post;

  const BookmarkButton({super.key, required this.post});

  @override
  ConsumerState<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends ConsumerState<BookmarkButton> {
  bool isAnimating = false;

  @override
  Widget build(BuildContext context) {
    final isBookmarked =
        ref.watch(bookmarksProvider.select((list) => list.contains(widget.post)));

    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: Icon(
          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          key: ValueKey(isBookmarked),
          size: 25,
          color: isBookmarked ? Colors.blue : Colors.grey,
        ),
      ),
      onPressed: () async {
        setState(() {
          isAnimating = true;
        });

        // Toggle bookmark in Riverpod state
        await ref.read(bookmarksProvider.notifier).toggleBookmark(widget.post);

        // Simple animation delay
        await Future.delayed(const Duration(milliseconds: 200));
        if (mounted) {
          setState(() {
            isAnimating = false;
          });
        }
      },
    );
  }
}

