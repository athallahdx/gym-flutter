import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileUpdateRequested extends ProfileEvent {
  final String name;
  final String? email;
  final String? phone;
  final String? profileBio;

  const ProfileUpdateRequested({
    required this.name,
    this.email,
    this.phone,
    this.profileBio,
  });

  @override
  List<Object?> get props => [name, email, phone, profileBio];
}

class ProfileChangePasswordRequested extends ProfileEvent {
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  const ProfileChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  @override
  List<Object?> get props => [
    currentPassword,
    newPassword,
    newPasswordConfirmation,
  ];
}
