part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class LoadingGetUserState extends UserState {}
final class SuccessGetUserState extends UserState {}
final class FailedGetUserState extends UserState {
  final String error;
  FailedGetUserState(this.error);
}
