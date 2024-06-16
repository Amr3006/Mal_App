part of 'anime_cubit.dart';

@immutable
sealed class AnimeState {}

final class AnimeInitial extends AnimeState {}

final class LoadingTopAnimeState extends AnimeState {}
final class SuccessTopAnimeState extends AnimeState {}
final class FailedTopAnimeState extends AnimeState {
  final String error;
  FailedTopAnimeState(this.error);
}
