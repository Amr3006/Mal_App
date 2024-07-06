part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class LoadingDataState extends SearchState {}
final class SuccessDataState extends SearchState {}
final class FailedDataState extends SearchState {
  final String error;

  FailedDataState(this.error);
}

final class LoadingMoreDataState extends SearchState {}
final class SuccessMoreDataState extends SearchState {}
final class FailedMoreDataState extends SearchState {
  final String error;

  FailedMoreDataState(this.error);
}
