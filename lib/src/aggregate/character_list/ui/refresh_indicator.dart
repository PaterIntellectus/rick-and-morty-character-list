import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/bloc/bloc.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/filter.dart';

class CharacterRefreshIndicator extends StatelessWidget {
  const CharacterRefreshIndicator({
    super.key,
    required this.child,
    this.filter,
  });

  final Widget child;
  final CharacterFilter? filter;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: child,
      onRefresh: () async => context.read<CharacterListBloc>().add(
        CharacterListSubscribed(filter: filter),
      ),
    );
  }
}
