part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

final class ChangeObscurityState extends SignUpState{}

final class LoadingSignUpWithEmailAndPasswordState extends SignUpState{}
final class SuccessSignUpWithEmailAndPasswordState extends SignUpState{}
final class FailedSignUpWithEmailAndPasswordState extends SignUpState{
  final String error;
  FailedSignUpWithEmailAndPasswordState(this.error);
}

final class LoadingCreateUserWithEmailAndPasswordState extends SignUpState{}
final class SuccessCreateUserWithEmailAndPasswordState extends SignUpState{}
final class FailedCreateUserWithEmailAndPasswordState extends SignUpState{
  final String error;
  FailedCreateUserWithEmailAndPasswordState(this.error);
}

