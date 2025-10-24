import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';

class CharacterImage extends StatelessWidget {
  const CharacterImage({
    super.key,
    required this.imagePath,
    required this.characterStatus,
  });

  final Uri imagePath;
  final CharacterStatus characterStatus;

  @override
  Widget build(BuildContext context) {
    final image = Image.network(imagePath.toString(), fit: BoxFit.cover);

    if (characterStatus == CharacterStatus.dead) {
      // return ColorFiltered(
      //   colorFilter: ColorFilter.matrix(<double>[
      //     ...[0.2126, 0.7152, 0.0722, 0, 0],
      //     ...[0.2126, 0.7152, 0.0722, 0, 0],
      //     ...[0.2126, 0.7152, 0.0722, 0, 0],
      //     ...[0, 0, 0, 1, 0],
      //   ]),
      //   child: image,
      // );

      return Stack(
        fit: StackFit.expand,
        children: [
          image,

          Positioned(
            left: -40,
            top: 4,
            child: Transform.rotate(
              angle: (pi / 180) * -45,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 4,
                ),
                color: Colors.red.withValues(alpha: .8),
                child: const Text(
                  'DEAD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return image;
  }
}
