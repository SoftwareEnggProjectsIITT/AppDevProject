import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:frontend/models/post_data.dart';
import 'package:frontend/widgets/bookmark_button.dart';
import 'package:frontend/widgets/post_image.dart';
import 'package:url_launcher/url_launcher.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.post});
  final PostData post;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  String preprocessText(String input) {
    return input
      .replaceAll(RegExp(r'\[at\]', caseSensitive: false), '@')
      .replaceAll(RegExp(r'\[dot\]', caseSensitive: false), '.');
  }

  Future<void> onLinkOpen(BuildContext context, String url) async {
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.parse(url);

    if (uri.scheme == 'mailto') {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        messenger.showSnackBar(
          SnackBar(content: Text("Could not open email client for ${uri.path}")),
        );
      }
    } 
    else {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        messenger.showSnackBar(
          SnackBar(content: Text("Could not open $url")),
        );
      }
    }  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          BookmarkButton(post: widget.post),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Hero(
              tag: widget.post.image_link,
              child: PostImage(url: widget.post.image_link)
            ),
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
            SelectableLinkify(
              text: preprocessText("${widget.post.body} https://x.com/"),
              style: const TextStyle(fontSize: 16),
              linkStyle: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              onOpen: (link) async {
                onLinkOpen(context, link.url);
              },
              options: const LinkifyOptions(humanize: false),
              contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
                return AdaptiveTextSelectionToolbar.editableText(
                  editableTextState: editableTextState
                );
              },
            ),
            const SizedBox(height: 24),

            // Date field
            Text(
              "Posted on: ${widget.post.date}",
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
