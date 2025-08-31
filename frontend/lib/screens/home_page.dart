import 'package:flutter/material.dart';
import 'package:frontend/models/post_data.dart';
import 'package:frontend/services/post_service.dart';
import 'package:frontend/widgets/post_card.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

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
    if (mounted) {
      setState(() {
        _posts = posts;
      });
    }
  }

  Future<void> _handleRefresh() async {
    await _loadPosts(); // reload posts from database
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text("Posts", style: TextStyle(fontSize: 20)),
        ),
        Expanded(
          child: LiquidPullToRefresh(
            onRefresh: _handleRefresh,
            color: Colors.blue,
            backgroundColor: Colors.white,
            showChildOpacityTransition: false,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(), // ensures pull works even if list is short
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return PostCard(post: post);
              },
            ),
          ),
        ),
      ],
    );
  }
}

