part of 'anime_details_cubit.dart';

@immutable
sealed class DetailedAnimeState {}

final class DetailedAnimeInitial extends DetailedAnimeState {}

final class LoadingDataState extends DetailedAnimeState {}
final class SuccessDataState extends DetailedAnimeState {}
final class FailedDataState extends DetailedAnimeState {
  final String error;

  FailedDataState(this.error);
}
final class LoadingUploadRecentState extends DetailedAnimeState {}
final class SuccessUploadRecentState extends DetailedAnimeState {}
final class FailedUploadRecentState extends DetailedAnimeState {
  final String error;

  FailedUploadRecentState(this.error);
}
final class LoadingFavouriteState extends DetailedAnimeState {}
final class SuccessFavouriteState extends DetailedAnimeState {}
final class FailedFavouriteState extends DetailedAnimeState {
  final String error;

  FailedFavouriteState(this.error);
}
