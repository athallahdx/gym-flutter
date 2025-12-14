import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/app/data/repositories/auth_repository.dart';
import 'package:gym_app/app/modules/auth/bloc/auth_event.dart';
import 'package:gym_app/app/modules/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthProfileUpdated>(_onProfileUpdated);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.login(
      email: event.email,
      password: event.password,
    );

    if (result['success']) {
      emit(AuthAuthenticated(user: result['user'], token: result['token']));
    } else {
      emit(AuthError(message: result['message']));
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.register(
      name: event.name,
      email: event.email,
      password: event.password,
      passwordConfirmation: event.passwordConfirmation,
      phone: event.phone,
      profileBio: event.profileBio,
    );

    if (result['success']) {
      emit(AuthAuthenticated(user: result['user'], token: result['token']));
    } else {
      emit(AuthError(message: result['message']));
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    await authRepository.logout();

    emit(const AuthUnauthenticated());
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final isLoggedIn = await authRepository.isLoggedIn();

    if (isLoggedIn) {
      final result = await authRepository.getProfile();
      if (result['success']) {
        emit(
          AuthAuthenticated(
            user: result['user'],
            token: '', // Token already stored
          ),
        );
      } else {
        emit(const AuthUnauthenticated());
      }
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onProfileUpdated(
    AuthProfileUpdated event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      emit(AuthAuthenticated(
        user: event.user,
        token: currentState.token,
      ));
    }
  }
}
