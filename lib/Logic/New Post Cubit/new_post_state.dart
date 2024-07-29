part of 'new_post_cubit.dart';

@immutable
sealed class NewPostState {}

final class NewPostInitial extends NewPostState {}

final class PickedImagesState extends NewPostState {}
final class RemovedImageState extends NewPostState {}

final class AddedAnimeState extends NewPostState {}
final class RemovedAnimeState extends NewPostState {}

final class SuccessUploadImagesState extends NewPostState {}
final class LoadingUploadImagesState extends NewPostState {}
final class FailedUploadImagesState extends NewPostState {
  final String error;
  FailedUploadImagesState(this.error);
}

final class SuccessUploadAnimesState extends NewPostState {}
final class LoadingUploadAnimesState extends NewPostState {}
final class FailedUploadAnimesState extends NewPostState {
  final String error;
  FailedUploadAnimesState(this.error);
}

final class SuccessUploadPostState extends NewPostState {}
final class LoadingUploadPostState extends NewPostState {}
final class FailedUploadPostState extends NewPostState {
  final String error;
  FailedUploadPostState(this.error);
}
