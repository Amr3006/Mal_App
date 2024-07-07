part of 'feed_cubit.dart';

@immutable
sealed class FeedState {}

final class FeedInitial extends FeedState {}

final class LoadingTopAnimeState extends FeedState {}
final class SuccessTopAnimeState extends FeedState {}
final class FailedTopAnimeState extends FeedState {
  final String error;
  FailedTopAnimeState(this.error);
}

final class LoadingSeasonAnimeState extends FeedState {}
final class SuccessSeasonAnimeState extends FeedState {}
final class FailedSeasonAnimeState extends FeedState {
  final String error;
  FailedSeasonAnimeState(this.error);
}

final class LoadingPopularCharactersState extends FeedState {}
final class SuccessPopularCharactersState extends FeedState {}
final class FailedPopularCharactersState extends FeedState {
  final String error;
  FailedPopularCharactersState(this.error);
}

final class LoadingRecentAnimesState extends FeedState {}
final class SuccessRecentAnimesState extends FeedState {}
final class FailedRecentAnimesState extends FeedState {
  final String error;
  FailedRecentAnimesState(this.error);
}
