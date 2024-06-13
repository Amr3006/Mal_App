part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class ChangeObscurtityState extends LoginState {}

final class LoadingLoginWithEmailAndPasswordState extends LoginState{}
final class SuccessLoginWithEmailAndPasswordState extends LoginState{}
final class FailedLoginWithEmailAndPasswordState extends LoginState{
  final String error;
  FailedLoginWithEmailAndPasswordState(this.error);
}
