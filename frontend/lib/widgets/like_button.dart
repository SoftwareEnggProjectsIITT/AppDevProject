import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onTap;

  const LikeButton({super.key, required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
        child: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(isLiked),
          size: 25,
          color: isLiked ? Colors.red : Colors.grey,
        ),
      ),
      onPressed: onTap,
    );
  }
}

