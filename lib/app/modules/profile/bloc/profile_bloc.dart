import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/app/data/models/user.dart';
import 'package:gym_app/app/data/repositories/auth_repository.dart';

// Events
class ProfileUpdateRequested {
  final String name;
  final String? email;
  final String? phone;
  final String? profileBio;

  ProfileUpdateRequested({
    required this.name,
    this.email,
    this.phone,
    this.profileBio,
  });
}

class ProfileChangePasswordRequested {
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  ProfileChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });
}

// States
class ProfileInitial {}
class ProfileLoading {}

class ProfileUpdateSuccess {
  final User user;
  final String message;
  ProfileUpdateSuccess({required this.user, required this.message});
}

class ProfileChangePasswordSuccess {
  final String message;
  ProfileChangePasswordSuccess({required this.message});
}

class ProfileError {
  final String message;
  ProfileError({required this.message});
}

// Bloc
class ProfileBloc extends Bloc<Object, Object> {
  final AuthRepository authRepository;

  ProfileBloc({required this.authRepository}) : super(ProfileInitial()) {
    on<ProfileUpdateRequested>(_onUpdateProfileRequested);
    on<ProfileChangePasswordRequested>(_onChangePasswordRequested);
  }

  Future<void> _onUpdateProfileRequested(
    ProfileUpdateRequested event,
    Emitter<Object> emit,
  ) async {
    emit(ProfileLoading());

    final result = await authRepository.updateProfile(
      name: event.name,
      email: event.email,
      phone: event.phone,
      profileBio: event.profileBio,
    );

    if (result['success']) {
      emit(ProfileUpdateSuccess(user: result['user'], message: result['message']));
    } else {
      emit(ProfileError(message: result['message']));
    }
  }

  Future<void> _onChangePasswordRequested(
    ProfileChangePasswordRequested event,
    Emitter<Object> emit,
  ) async {
    emit(ProfileLoading());

    final result = await authRepository.changePassword(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
      newPasswordConfirmation: event.newPasswordConfirmation,
    );

    if (result['success']) {
      emit(ProfileChangePasswordSuccess(message: result['message']));
    } else {
      emit(ProfileError(message: result['message']));
    }
  }
}
