import 'package:flutter/material.dart';
import 'package:frontend/models/post_data.dart';
import 'package:frontend/screens/post_page.dart';
import 'package:frontend/widgets/bookmark_button.dart';
import 'package:frontend/widgets/like_button.dart';
import 'package:frontend/widgets/post_image.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.post, required this.needLike});
  final PostData post;
  final bool needLike;

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

              const SizedBox(height: 12),

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post.category,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.post.date.trim(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 8),

              // Like, bookmark
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Like button
                  widget.needLike 
                  ? Row(
                    children: [
                      LikeButton(
                        isLiked: isLiked,
                        onTap: () {
                          setState(() {
                            if (!isLiked) {
                              widget.post.likes++;
                            }
                            else {
                              widget.post.likes--;
                            }
                            isLiked = !isLiked;
                          });
                        },
                      ),
                      Text(
                        widget.post.likes.toString(),
                      ),
                    ],
                  ) 
                  : SizedBox.shrink(),
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

