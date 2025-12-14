import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/app/data/repositories/auth_repository.dart';
import 'package:gym_app/app/modules/auth/bloc/auth_bloc.dart';
import 'package:gym_app/app/modules/auth/bloc/auth_event.dart';
import 'package:gym_app/app/modules/auth/bloc/auth_state.dart';
import 'package:gym_app/app/modules/profile/bloc/profile_bloc.dart';
import 'package:gym_app/app/modules/profile/screens/update_profile_page.dart';
import 'package:gym_app/app/modules/profile/screens/update_password_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        context.read<AuthBloc>().add(
                          const AuthLogoutRequested(),
                        );
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            final user = state.user;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: user.profileImage != null
                        ? NetworkImage(user.fullProfileImageUrl)
                        : null,
                    child: user.profileImage == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(user.role.toUpperCase()),
                    backgroundColor: Colors.blue.shade100,
                  ),
                  const SizedBox(height: 32),

                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.phone),
                          title: const Text('Phone'),
                          subtitle: Text(user.phone ?? 'Not set'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.card_membership),
                          title: const Text('Membership Status'),
                          subtitle: Text(
                            user.isMembershipActive ? 'Active' : 'Inactive',
                          ),
                          trailing: Icon(
                            user.isMembershipActive
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: user.isMembershipActive
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        if (user.membershipEndDate != null) ...[
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: const Text('Membership Expires'),
                            subtitle: Text(
                              '${user.membershipEndDate!.day}/${user.membershipEndDate!.month}/${user.membershipEndDate!.year}',
                            ),
                          ),
                        ],
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.verified),
                          title: const Text('Email Verified'),
                          trailing: Icon(
                            user.isEmailVerified
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: user.isEmailVerified
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit Profile'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => ProfileBloc(
                                    authRepository: AuthRepository(),
                                  ),
                                  child: const UpdateProfilePage(),
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.lock),
                          title: const Text('Change Password'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => ProfileBloc(
                                    authRepository: AuthRepository(),
                                  ),
                                  child: const UpdatePasswordPage(),
                                ),
                              ),
                            );
                          },
                        ),
                        // const Divider(height: 1),
                        // ListTile(
                        //   leading: const Icon(Icons.settings),
                        //   title: const Text('Settings'),
                        //   trailing: const Icon(Icons.chevron_right),
                        //   onTap: () {
                        //     // TODO: Navigate to settings
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
