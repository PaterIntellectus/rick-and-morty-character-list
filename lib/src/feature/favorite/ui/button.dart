import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.isFavorite, this.onPressed});

  final bool isFavorite;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.amber,
      onPressed: onPressed,
      icon: isFavorite ? Icon(Icons.star) : Icon(Icons.star_border),
    );
  }
}
