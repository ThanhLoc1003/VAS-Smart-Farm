import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../result_type.dart';
import '../data/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginStarted>(_onLoginStarted);
    on<AuthRegisterStarted>(_onRegisterStarted);
    on<AuthLoginPrefilled>(_onLoginPrefilled);
    on<AuthAuthenticateStarted>(_onAuthenticateStarted);
    on<AuthLogoutStarted>(_onLogoutStarted);
  }

  final AuthRepository authRepository;
  void _onStarted(AuthStarted event, Emitter<AuthState> emit) {
    emit(AuthAuthenticateUnauthenticated());
  }

  void _onLoginStarted(AuthLoginStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoginInProgress()); // Chuyển trạng thái
    await Future.delayed(500.milliseconds);
    // try {
    //    final isLoggedIn = await authRepository.login(event.email, event.password);
    //   emit(AuthLoginSuccess());
    // }
    // catch DioException as e {
    //   emit(AuthLoginFailure(message: e.message.toString()));
    // }

    final result = await authRepository.login(event.email, event.password);
    return switch (result) {
      Success() => emit(AuthLoginSuccess()),
      Failure() => emit(AuthLoginFailure(message: result.message)),
    };
  }

  void _onRegisterStarted(
      AuthRegisterStarted event, Emitter<AuthState> emit) async {
    emit(AuthRegisterInProgress());
    await Future.delayed(500.milliseconds);
    final result = await authRepository.register(
        event.username, event.email, event.password);
    return switch (result) {
      Success() => emit(AuthRegisterSuccess()),
      Failure() => emit(AuthRegisterFailure(message: result.message)),
    };
  }

  void _onLoginPrefilled(
      AuthLoginPrefilled event, Emitter<AuthState> emit) async {
    emit(AuthLoginInitial(email: event.email, password: event.password));
  }

  void _onAuthenticateStarted(
      AuthAuthenticateStarted event, Emitter<AuthState> emit) async {
    final result = await authRepository.getRole();
    return (switch (result) {
      Success(data: final role) when role != null =>
        emit(AuthAuthenticateSuccess(role)),
      Success() => emit(AuthAuthenticateUnauthenticated()),
      Failure() => emit(AuthLoginFailure(message: result.message)),
    });
  }

  void _onLogoutStarted(
      AuthLogoutStarted event, Emitter<AuthState> emit) async {
    final result = await authRepository.logout();
    return switch (result) {
      Success() => emit(AuthLogoutSuccess()),
      Failure() => emit(AuthLoginFailure(message: result.message)),
    };
  }
}
