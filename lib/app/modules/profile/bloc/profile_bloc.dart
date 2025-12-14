import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/app/data/repositories/auth_repository.dart';
import 'package:gym_app/app/modules/profile/bloc/profile_event.dart';
import 'package:gym_app/app/modules/profile/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;

  ProfileBloc({required this.authRepository}) : super(const ProfileInitial()) {
    on<ProfileUpdateRequested>(_onUpdateProfileRequested);
    on<ProfileChangePasswordRequested>(_onChangePasswordRequested);
  }

  Future<void> _onUpdateProfileRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await authRepository.updateProfile(
      name: event.name,
      email: event.email,
      phone: event.phone,
      profileBio: event.profileBio,
    );

    if (result['success']) {
      emit(
        ProfileUpdateSuccess(user: result['user'], message: result['message']),
      );
    } else {
      emit(ProfileError(message: result['message']));
    }
  }

  Future<void> _onChangePasswordRequested(
    ProfileChangePasswordRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

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
