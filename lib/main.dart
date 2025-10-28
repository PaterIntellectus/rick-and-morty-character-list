import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_character_list/src/app/ui/app.dart';

void main() {
  Bloc.observer = BlocLogger();

  runApp(const App());
}

class BlocLogger extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    debugPrint("Bloc: ${bloc.runtimeType} created");
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    debugPrint("Bloc: ${bloc.runtimeType}; Event: $event");
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    debugPrint(
      "Bloc: ${bloc.runtimeType}; Transition: ${transition.currentState.runtimeType} -> ${transition.nextState.runtimeType}",
    );
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint(
      "Bloc: ${bloc.runtimeType}; Error: ${error.runtimeType}('${error.toString()}')",
    );
    super.onError(bloc, error, stackTrace);
  }
}
