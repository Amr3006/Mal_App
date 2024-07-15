part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class ChangeNavigationBarPageState extends HomeState {}

final class LoadingRandomAnimeState extends HomeState {}
final class SucceedRandomAnimeState extends HomeState {}
final class FailedRandomAnimeState extends HomeState {
  final String error;
  FailedRandomAnimeState(this.error);
}
