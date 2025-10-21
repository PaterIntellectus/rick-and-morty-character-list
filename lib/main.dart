import 'package:flutter/material.dart';
import 'package:rick_and_morty_character_list/shared/data/api/client.dart';
import 'package:rick_and_morty_character_list/ui/app.dart';

void main() async {
  final characters = await RickAndMortyRestApiClient.allCharactets();

  print('Получено персонажей: ${characters.results.length}');

  runApp(const App());
}
