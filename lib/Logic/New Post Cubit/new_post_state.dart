part of 'new_post_cubit.dart';

@immutable
sealed class NewPostState {}

final class NewPostInitial extends NewPostState {}

final class PickedImagesState extends NewPostState {}
final class RemovedImageState extends NewPostState {}

final class PickedAnimeState extends NewPostState {}
final class RemovedAnimeState extends NewPostState {}

final class SuccessUploadImagesState extends NewPostState {}
final class LoadingUploadImagesState extends NewPostState {}
final class FailedUploadImagesState extends NewPostState {
  final String error;
  FailedUploadImagesState(this.error);
}
