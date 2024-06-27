part of 'anime_details_cubit.dart';

@immutable
sealed class DetailedAnimeState {}

final class DetailedAnimeInitial extends DetailedAnimeState {}

final class ChangeEdgeState extends DetailedAnimeState {}

final class LoadingDataState extends DetailedAnimeState {}
final class SuccessDataState extends DetailedAnimeState {}
final class FailedDataState extends DetailedAnimeState {
  final String error;

  FailedDataState(this.error);
}
