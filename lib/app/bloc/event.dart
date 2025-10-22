part of 'bloc.dart';

sealed class AppEvent with EquatableMixin {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

final class AppStarted extends AppEvent {
  const AppStarted();
}
