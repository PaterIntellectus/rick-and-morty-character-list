import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/bloc/bloc.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';
import 'package:rick_and_morty_character_list/src/shared/lib/string/string.dart';

class CharacterSorter extends StatelessWidget {
  const CharacterSorter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterListBloc, CharacterListState>(
      buildWhen: (previous, current) => previous.sorting != current.sorting,
      builder: (context, state) {
        Widget icon = Icon(Icons.sort);

        if (state.sorting.order == CharacterSortOrder.descending) {
          icon = Transform.scale(scaleY: -1, child: icon);
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              icon: Icon(Icons.list),
              label: Text(state.sorting.param?.name.capitalise() ?? 'Sort'),
              onPressed: () {
                context.read<CharacterListBloc>().add(
                  CharacterListSorted(
                    sorting: CharacterSorting(
                      order: state.sorting.order,
                      param:
                          state.sorting.param?.next() ??
                          CharacterSortParam.name,
                    ),
                  ),
                );
              },
            ),

            TextButton.icon(
              iconAlignment: IconAlignment.end,
              icon: icon,
              label: Text(state.sorting.order.name.capitalise()),
              onPressed: () {
                context.read<CharacterListBloc>().add(
                  CharacterListSorted(
                    sorting: CharacterSorting(
                      order: state.sorting.order.toggle(),
                      param: state.sorting.param,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
