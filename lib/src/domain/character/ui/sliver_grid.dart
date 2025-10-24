import 'package:flutter/widgets.dart';

class CharacterSliverGrid extends StatelessWidget {
  const CharacterSliverGrid({
    super.key,
    this.totalCharacterCount,
    this.gridDelegate,
    required this.itemBuilder,
  });

  final int? totalCharacterCount;
  final SliverGridDelegate? gridDelegate;
  final Widget? Function(BuildContext context, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      delegate: SliverChildBuilderDelegate(
        itemBuilder,
        childCount: totalCharacterCount,
      ),
    );
  }
}
