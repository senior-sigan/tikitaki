import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
    required this.isFavorite,
    required this.onToggle,
  });

  final bool isFavorite;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onToggle,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.white,
        size: 36,
      ),
    );
  }
}
