part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class PickingImageState extends ProfileState {}

final class ChangeEditModeState extends ProfileState {}

final class SuccessLogoutState extends ProfileState {}
final class FailedLogoutState extends ProfileState {}

final class LoadingGetUserState extends ProfileState {}
final class SuccessGetUserState extends ProfileState {}
final class FailedGetUserState extends ProfileState {
  final String error;
  FailedGetUserState(this.error);
}

final class LoadingChangeProfilePictureState extends ProfileState {}
final class SuccessChangeProfilePictureState extends ProfileState {}
final class FailedChangeProfilePictureState extends ProfileState {
  final String error;
  FailedChangeProfilePictureState(this.error);
}

final class LoadingChangeNameState extends ProfileState {}
final class SuccessChangeNameState extends ProfileState {}
final class FailedChangeNameState extends ProfileState {
  final String error;
  FailedChangeNameState(this.error);
}
