import 'package:flutter/material.dart';
import 'package:gym_app/app/modules/auth/screens/login_page.dart';
import 'package:gym_app/app/modules/auth/screens/register_page.dart';
import 'package:gym_app/app/modules/dashboard/screens/dashboard_page.dart';
import 'package:gym_app/app/modules/gym_classes/screens/gym_classes_page.dart';
import 'package:gym_app/app/modules/membership/screens/membership_page.dart';
import 'package:gym_app/app/modules/profile/screens/profile_page.dart';
import 'package:gym_app/app/modules/payments/screens/payments_page.dart';

class AppRoutes {
  // Auth Routes
  static const String login = '/login';
  static const String register = '/register';

  // Main Routes (Protected)
  static const String dashboard = '/dashboard';
  static const String gymClasses = '/gym-classes';
  static const String membership = '/membership';
  static const String payments = '/payments';
  static const String profile = '/profile';

  // Route Generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      
      case gymClasses:
        return MaterialPageRoute(builder: (_) => const GymClassesPage());
      
      case membership:
        return MaterialPageRoute(builder: (_) => const MembershipPage());

      case payments:
        return MaterialPageRoute(builder: (_) => const PaymentsPage());
      
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  // Navigation Helpers
  static void navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, login);
  }

  static void navigateToRegister(BuildContext context) {
    Navigator.pushNamed(context, register);
  }

  static void navigateToDashboard(BuildContext context) {
    Navigator.pushReplacementNamed(context, dashboard);
  }

  static void navigateToGymClasses(BuildContext context) {
    Navigator.pushNamed(context, gymClasses);
  }

  static void navigateToMembership(BuildContext context) {
    Navigator.pushNamed(context, membership);

  }
  static void navigateToPayments(BuildContext context) {
    Navigator.pushNamed(context, payments);
  }

  static void navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, profile);
  }
}
