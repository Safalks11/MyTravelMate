part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class HomeInitialEvent extends HomeEvent {}

final class NavigateToNextScreenEvent extends HomeEvent {
  final int index;
  NavigateToNextScreenEvent(this.index);
}
