import 'package:firebase_database/firebase_database.dart';
import 'package:frontend/models/post_data.dart';

class PostService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("posts");

  Future<List<PostData>> fetchPosts() async {
    final snapshot = await _dbRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data.values
          .map((e) => PostData.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> addPost(PostData post) async {
    await _dbRef.push().set(post.toJson());
  }
}
