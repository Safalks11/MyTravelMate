import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  int currentIndex = 0; // Add currentIndex to track the active tab

  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(_onHomeInitialEvent);

    on<NavigateToNextScreenEvent>(_onNavigateToNextScreenEvent);
  }

  FutureOr<void> _onHomeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) {
    emit(HomeSuccess());
  }

  FutureOr<void> _onNavigateToNextScreenEvent(
      NavigateToNextScreenEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    currentIndex = event.index;

    // Update current index and emit success state
    emit(HomeSuccess());
  }
}
