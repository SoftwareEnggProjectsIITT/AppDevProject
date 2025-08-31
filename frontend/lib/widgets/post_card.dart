import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/models/post_data.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});
  final PostData post;

  Widget buildPostImage(String url, BuildContext context) {
    if (url.toLowerCase().endsWith('.svg')) {
    return Center(
      child: SvgPicture.network(
        url,
        height: 250,
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onSurface, 
          BlendMode.srcIn
        ),
        placeholderBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    } else {
      return Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.cover,
          );
        },
      );
    }
  }
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            buildPostImage(post.image_link, context),

            // Title
            Text(
              post.title.trim(),
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
              children: [
                const Icon(Icons.favorite, size: 25, color: Colors.red),
                const SizedBox(width: 4),
                Text("${post.likes}"),
                const SizedBox(width: 4),
                const Icon(Icons.bookmark, size: 25, color: Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

