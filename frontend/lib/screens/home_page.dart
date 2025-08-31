import 'package:flutter/material.dart';
import 'package:frontend/models/post_data.dart';
import 'package:frontend/services/post_service.dart';
import 'package:frontend/widgets/post_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final PostService _postService = PostService();
  List<PostData> _posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    List<PostData> posts = await _postService.fetchPosts();
    setState(() {
      _posts = posts;
    });
  }

 @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Posts", style: TextStyle(fontSize: 20)),
        Expanded(
          child: ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              final post = _posts[index];
              return PostCard(post: post);
            },
          ),
        ),
      ],
    );
  }
}
