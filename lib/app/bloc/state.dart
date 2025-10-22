part of 'bloc.dart';

sealed class AppState with EquatableMixin {
  const AppState();

  @override
  List<Object?> get props => const [];
}

final class AppStarting extends AppState {
  const AppStarting();
}

final class AppSucess extends AppState {
  const AppSucess({required this.characterRepository});

  final CharacterRepository characterRepository;

  @override
  List<Object?> get props => [...super.props, characterRepository];
}

final class AppFailure extends AppState {
  const AppFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [...super.props, message];
}
