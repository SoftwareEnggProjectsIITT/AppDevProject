import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/post_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final bookmarksProvider =
    StateNotifierProvider<BookmarksNotifier, List<PostData>>(
  (ref) => BookmarksNotifier(),
);

class BookmarksNotifier extends StateNotifier<List<PostData>> {
  BookmarksNotifier() : super([]) {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('bookmarks') ?? [];
    state = data.map((e) => PostData.fromJson(jsonDecode(e))).toList();
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = state.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList('bookmarks', data);
  }

  Future<void> toggleBookmark(PostData post) async {
    if (state.contains(post)) {
      state = state.where((p) => p != post).toList();
    } else {
      state = [...state, post];
    }
    await _saveBookmarks();
  }

  bool isBookmarked(PostData post) => state.contains(post);
}

