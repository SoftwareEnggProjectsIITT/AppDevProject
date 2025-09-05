import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:frontend/models/feed_entry.dart';
import 'package:frontend/models/post_data.dart';
import 'package:http/http.dart' as http;

class PostService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("posts");
  final DatabaseReference _dbUserRef = FirebaseDatabase.instance.ref("users");

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
      Uri.parse("https://appdevproject-umx9.onrender.com/chats/feed/$userId"),
    );

    if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);

    final feed = decoded['feed'] as List<dynamic>;

    return feed.map((entry) {
      final map = Map<String, dynamic>.from(entry);
      return FeedEntry.fromMap(map);
    }).toList();
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

  // add likes to a post
  Future<void> addRemoteLikes(
    String id,
    double delta,
  ) async {
    final postRef = _dbRef.child(id).child("likes");

    await postRef.runTransaction((currentLikes) {
      if (currentLikes == null) {
        return Transaction.success(delta);
      }
      final updatedLikes = (currentLikes as int) + delta;
      return Transaction.success(updatedLikes);
    });
  }

  // increase category score for a user
  Future<void> increaseCategoryScore(String category, int delta) async {
    final user = FirebaseAuth.instance.currentUser!;
    final categoryRef = _dbUserRef.child(user.uid).child(category);

    await categoryRef.runTransaction((currentScore) {
      if (currentScore == null) {
        return Transaction.success(delta);
      }

      final updatedScore = (currentScore as num).toInt() + delta;
      return Transaction.success(updatedScore);
    });
  }
}
