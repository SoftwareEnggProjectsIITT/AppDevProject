import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/feed_entry.dart';
import 'package:frontend/models/post_data.dart';
import 'package:frontend/services/post_service.dart';
import 'package:frontend/widgets/post_card.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PostService _postService = PostService();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  List<PostData> posts = []; // This is the one that fetches from firebase
  List<FeedEntry> feed = []; // This contains the order of posts a/c to user
  List<PostData> _posts = []; // These are the posts that finally renders

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
    setState(() {
      _isLoading = true;
    });

    posts = await _postService.fetchPosts();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    feed = await _postService.fetchFeedOrder(userId);
    posts = _postService.sortPostsByFeed(posts, feed);

    if (mounted) {
      setState(() {
        _posts = posts;
        _isLoading = false;
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
      body: _isLoading
      ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Lottie.asset('assets/animations/Loading_animation_blue.json'),

          Text(
            "Loading...", 
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      )
      : LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        showChildOpacityTransition: false,
        child: ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _posts.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("Posts", style: TextStyle(fontSize: 20)),
              );
            }
            final post = _posts[index - 1];
            return PostCard(
              post: post,
              needLike: true,
              postService: _postService,
            );
          },
        ),
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
