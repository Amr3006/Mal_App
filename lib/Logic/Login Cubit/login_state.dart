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

final class LoadingLoginWithGoogleState extends LoginState{}
final class SuccessLoginWithGoogleState extends LoginState{}
final class FailedLoginWithGoogleState extends LoginState{
  final String error;
  FailedLoginWithGoogleState(this.error);
}

final class LoadingLoginWithFacebookState extends LoginState{}
final class SuccessLoginWithFacebookState extends LoginState{}
final class FailedLoginWithFacebookState extends LoginState{
  final String error;
  FailedLoginWithFacebookState(this.error);
}
