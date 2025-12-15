import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/app/data/models/user.dart';
import 'package:gym_app/app/data/repositories/auth_repository.dart';

// Events
class AuthLoginRequested {
  final String email;
  final String password;
  AuthLoginRequested(this.email, this.password);
}

class AuthRegisterRequested {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String? phone;
  final String? profileBio;
  
  AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.phone,
    this.profileBio,
  });
}

class AuthLogoutRequested {}
class AuthCheckRequested {}

class AuthProfileUpdated {
  final User user;
  AuthProfileUpdated({required this.user});
}

// States
class AuthInitial {}
class AuthLoading {}
class AuthAuthenticated {
  final User user;
  final String token;
  AuthAuthenticated(this.user, this.token);
}
class AuthUnauthenticated {}
class AuthError {
  final String message;
  AuthError(this.message);
}

// Bloc
class AuthBloc extends Bloc<Object, Object> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthProfileUpdated>(_onProfileUpdated);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<Object> emit,
  ) async {
    emit(AuthLoading());

    final result = await authRepository.login(
      email: event.email,
      password: event.password,
    );

    if (result['success']) {
      emit(AuthAuthenticated(result['user'], result['token']));
    } else {
      emit(AuthError(result['message']));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<Object> emit,
  ) async {
    emit(AuthLoading());

    final result = await authRepository.register(
      name: event.name,
      email: event.email,
      password: event.password,
      passwordConfirmation: event.passwordConfirmation,
      phone: event.phone,
      profileBio: event.profileBio,
    );

    if (result['success']) {
      emit(AuthAuthenticated(result['user'], result['token']));
    } else {
      emit(AuthError(result['message']));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<Object> emit,
  ) async {
    emit(AuthLoading());
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<Object> emit,
  ) async {
    emit(AuthLoading());

    final isLoggedIn = await authRepository.isLoggedIn();

    if (isLoggedIn) {
      final result = await authRepository.getProfile();
      if (result['success']) {
        // Get the stored token for the authenticated state
        final token = await authRepository.getCurrentToken() ?? 'authenticated';
        emit(AuthAuthenticated(result['user'], token));
      } else {
        // Token might be invalid, clear it
        await authRepository.logout();
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onProfileUpdated(
    AuthProfileUpdated event,
    Emitter<Object> emit,
  ) async {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      emit(AuthAuthenticated(event.user, currentState.token));
    }
  }
}
