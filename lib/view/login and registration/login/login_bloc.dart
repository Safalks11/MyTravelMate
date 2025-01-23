import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../controller/firebase_helper/firebase_helper.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginUserEvent>(_onLoginUser);
    on<TogglePasswordVisibilityEvent>(_onTogglePassword);
  }

  FutureOr<void> _onLoginUser(
      LoginUserEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final firebaseHelper = FirebaseHelper();
      final errorMessage = await firebaseHelper.login(
          loginEmail: event.email, loginPass: event.password);
      if (errorMessage == null) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(errorMessage));
      }
    } catch (e) {
      emit(LoginFailure("An unexpected error occurred: ${e.toString()}"));
    }
  }

  FutureOr<void> _onTogglePassword(
      TogglePasswordVisibilityEvent event, Emitter<LoginState> emit) {
    emit(PasswordVisibilityToggled(showPassword: event.showPassword));
  }
}
