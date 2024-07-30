part of 'community_cubit.dart';

@immutable
sealed class CommunityState {}

final class CommunityInitial extends CommunityState {}

final class LoadingPostsState extends CommunityState {}
final class SuccessPostsState extends CommunityState {}
final class FailedPostsState extends CommunityState {
  final String error;
  FailedPostsState(this.error);
}
