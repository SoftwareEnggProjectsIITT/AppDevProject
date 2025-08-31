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
  final ScrollController _scrollController = ScrollController();

  List<PostData> _posts = [];
  bool _showBackToTopButton = false;

  @override
  void initState() {
    super.initState();
    _loadPosts();

    _scrollController.addListener(() {
      if (_scrollController.offset > 300) {
        if (!_showBackToTopButton) {
          setState(() => _showBackToTopButton = true);
        }
      } else {
        if (_showBackToTopButton) {
          setState(() => _showBackToTopButton = false);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
    await _loadPosts();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  return PostCard(post: post);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _showBackToTopButton
          ? FloatingActionButton(
              mini: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward, size: 20),
            )
          : null,
    );
  }
}

