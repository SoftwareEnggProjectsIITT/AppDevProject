import 'package:flutter/material.dart';
import 'package:frontend/models/post_data.dart';
import 'package:frontend/screens/post_page.dart';
import 'package:frontend/widgets/bookmark_button.dart';
import 'package:frontend/widgets/like_button.dart';
import 'package:frontend/widgets/post_image.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.post});
  final PostData post;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => PostPage(
                post: widget.post
              )
            )
          );
        },

        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              PostImage(url: widget.post.image_link),
        
              // Title
              Text(
                widget.post.title.trim(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
        
              const SizedBox(height: 6),
        
              // Category
              Text(
                widget.post.category,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey,
                ),
              ),
        
              const SizedBox(height: 8),
        
              // Like, bookmark
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Like button
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
                      Text("${widget.post.likes + (isLiked ? 1 : 0)}"),
                    ],
                  ),
        
                  const SizedBox(width: 20),
        
                  // Bookmark button
                  BookmarkButton(post: widget.post),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

