import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/bloc/bloc.dart';
import 'package:rick_and_morty_character_list/src/domain/character/ui/repository_provider.dart';

class CharacterListProvider extends StatelessWidget {
  const CharacterListProvider({
    super.key,
    this.child,
    required this.builder,
    this.initialEvent,
  });

  final Widget? child;
  final Widget Function(BuildContext context, Widget? child) builder;
  final CharacterListEvent? initialEvent;

  @override
  Widget build(BuildContext context) {
    final repository = CharacterRepositoryProvider.of(context);

    return BlocProvider(
      create: (context) {
        final bloc = CharacterListBloc(repository);

        if (initialEvent != null) {
          bloc.add(initialEvent!);
        }

        return bloc;
      },
      child: Builder(builder: (context) => builder(context, child)),
    );
  }
}
