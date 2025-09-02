import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostImage extends StatelessWidget {
  const PostImage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.toLowerCase().endsWith('.svg')) {
      return Center(
        child: SvgPicture.network(
          url,
          height: 250,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onSurface,
            BlendMode.srcIn,
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
}
