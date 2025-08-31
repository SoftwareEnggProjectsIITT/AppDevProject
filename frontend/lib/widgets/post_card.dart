import 'package:flutter/material.dart';
import 'package:frontend/models/post_data.dart';

class PostCard extends StatelessWidget {
  final PostData post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            // Category
            Text(
              post.category,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blueGrey,
              ),
            ),

            const SizedBox(height: 8),

            // Body
            // Text(
            //   post.body,
            //   style: const TextStyle(fontSize: 16),
            // ),
            //
            // const SizedBox(height: 12),

            // Footer row: likes + data
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite, size: 18, color: Colors.red),
                    const SizedBox(width: 4),
                    Text("${post.likes}"),
                  ],
                ),
                // Text(
                //   post.data, // assuming this is like a date string
                //   style: const TextStyle(color: Colors.grey),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

