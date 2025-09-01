import 'package:flutter/material.dart';
import 'package:frontend/models/post_data.dart';
import 'package:frontend/widgets/like_button.dart';
import 'package:frontend/widgets/bookmark_button.dart';
import 'package:frontend/widgets/post_image.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.post});
  final PostData post;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool isLiked = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            PostImage(url: widget.post.image_link),
            const SizedBox(height: 12),

            // Category
            Text(
              widget.post.category,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              widget.post.title.trim(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Body
            Text(
              widget.post.body,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),

            // Footer: Likes + Bookmark
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    LikeButton(
                      isLiked: isLiked,
                      onTap: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                    ),
                    const SizedBox(width: 6),
                    Text("${widget.post.likes + (isLiked ? 1 : 0)} likes"),
                  ],
                ),
                BookmarkButton(post: widget.post),
              ],
            ),

            const SizedBox(height: 12),

            // Data field
            Text(
              "Posted on: ${widget.post.data}",
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

