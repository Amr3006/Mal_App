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
