import 'package:firebase_database/firebase_database.dart';
import 'package:frontend/models/post_data.dart';

class PostService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("posts");

  Future<List<PostData>> fetchPosts() async {
    final snapshot = await _dbRef.get();

    if (!snapshot.exists || snapshot.value == null) return [];

    final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

    return data.entries.map((entry) {
      final key = entry.key as String;
      final value = Map<String, dynamic>.from(entry.value);
      final post = PostData.fromJson(value);
      post.id = key; // attach Firebase key
      return post;
    }).toList();
  }

  Future<void> addPost(PostData post) async {
    await _dbRef.push().set(post.toJson());
  }
}
