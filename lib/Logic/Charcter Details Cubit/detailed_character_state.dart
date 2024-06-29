part of 'detailed_character_cubit.dart';

@immutable
sealed class DetailedCharacterState {}

final class DetailedCharacterInitial extends DetailedCharacterState {}


final class LoadingCharacterDetailsState extends DetailedCharacterState {}
final class SuccessCharacterDetailsState extends DetailedCharacterState {}
final class FailedCharacterDetailsState extends DetailedCharacterState {
  final String error;

  FailedCharacterDetailsState(this.error);
}