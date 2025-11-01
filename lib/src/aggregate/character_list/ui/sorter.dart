import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/bloc/bloc.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';

class CharacterSorter extends StatefulWidget {
  const CharacterSorter({super.key});

  @override
  State<CharacterSorter> createState() => _CharacterSorterState();
}

class _CharacterSorterState extends State<CharacterSorter> {
  var order = CharacterSortOrder.ascending;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterListBloc, CharacterListState>(
      buildWhen: (previous, current) => previous.sorting != current.sorting,
      builder: (context, state) {
        Widget icon = Icon(Icons.sort);

        if (order == CharacterSortOrder.ascending) {
          icon = Transform.scale(scaleY: -1, child: icon);
        }

        return IconButton(
          icon: icon,
          onPressed: () {
            setState(
              () => order = order == CharacterSortOrder.ascending
                  ? CharacterSortOrder.descending
                  : CharacterSortOrder.ascending,
            );

            context.read<CharacterListBloc>().add(
              CharacterListSorted(
                sorting: CharacterSorting(order: order, param: null),
              ),
            );
          },
          tooltip: 'Sort order (${order.name})',
        );
      },
    );
  }
}
