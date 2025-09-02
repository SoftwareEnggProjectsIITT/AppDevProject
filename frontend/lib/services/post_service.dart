import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:frontend/models/feed_entry.dart';
import 'package:frontend/models/post_data.dart';
import 'package:http/http.dart' as http;

class PostService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("posts");

  // get all the posts
  Future<List<PostData>> fetchPosts() async {
    final snapshot = await _dbRef.get();

    if (!snapshot.exists || snapshot.value == null) return [];

    final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

    return data.entries.map((entry) {
      final key = entry.key as String;
      final value = Map<String, dynamic>.from(entry.value);
      final post = PostData.fromJson(value);
      post.id = key;
      return post;
    }).toList();
  }

  // fetch the sorting order of the posts
  Future<List<FeedEntry>> fetchFeedOrder(String userId) async {
    final response = await http.get(
      Uri.parse("https://appdevproject-39ac.onrender.com/feed/$userId"),
    );

    if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);

    final feed = decoded['feed'] as List<dynamic>;

    return feed
        .map((entry) => FeedEntry.fromMap(Map<String, dynamic>.from(entry)))
        .toList();
    } else {
        throw Exception("Failed to fetch feed: ${response.statusCode}");
      }
  }

  // sort the posts
  List<PostData> sortPostsByFeed(
    List<PostData> posts,
    List<FeedEntry> feedOrder,
  ) {
    final indexMap = {
    for (int i = 0; i < feedOrder.length; i++) feedOrder[i].postId: i
  };

    posts.sort((a, b) {
      final indexA = indexMap[a.id] ?? posts.length;
      final indexB = indexMap[b.id] ?? posts.length;
      return indexA.compareTo(indexB);
    });

    return posts;
  }

  Future<void> increaseScoreRemote(
    String userId,
    String postId,
    double delta,
  ) async {
    final response = await http.post(
      Uri.parse("https://appdevproject-39ac.onrender.com/feed/$userId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "post_id": postId,
        "delta": delta,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update score: ${response.statusCode}");
    }
  }
}
