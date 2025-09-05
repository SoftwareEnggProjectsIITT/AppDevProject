import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class PostImage extends StatelessWidget {
  const PostImage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.toLowerCase().endsWith('.svg')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Center(
          child: SvgPicture.network(
            url,
            height: 250,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onSurface,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => Center(
              child: Lottie.asset('assets/animations/Loading_Files.json'),
            ),
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: Lottie.asset('assets/animations/Loading_Files.json'),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
            );
          },
        ),
      );
    }
  }
}
