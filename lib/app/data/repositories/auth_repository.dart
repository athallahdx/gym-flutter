import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:gym_app/app/data/models/user.dart';
import 'package:gym_app/app/core/providers/api_routes.dart';
import 'package:gym_app/app/core/services/user_info.dart';

class AuthRepository {
  final UserInfo _userInfo = UserInfo();

  /// Register a new user
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    String? profileBio,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.register),
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          if (phone != null) 'phone': phone,
          if (profileBio != null) 'profile_bio': profileBio,
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        // Save token and user data
        final token = data['data']['token'] as String;
        final user = User.fromJson(data['data']['user']);

        await _userInfo.setToken(token);
        await _userInfo.setUserID(user.id);

        return {
          'success': true,
          'message': data['message'],
          'user': user,
          'token': token,
        };
      } else {
        // Handle validation errors
        String errorMessage = data['message'] ?? 'Registration failed';
        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          errorMessage = errors.values.first[0];
        }

        return {'success': false, 'message': errorMessage};
      }
    } on SocketException {
      return {'success': false, 'message': 'No internet connection'};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  /// Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('Attempting login for email: $email'); // Debug log
      
      final response = await http.post(
        Uri.parse(ApiUrl.login),
        body: {'email': email, 'password': password},
      );

      print('Login response status: ${response.statusCode}'); // Debug log
      print('Login response body: ${response.body}'); // Debug log

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        // Save token and user data
        final token = data['data']['token'] as String;
        final user = User.fromJson(data['data']['user']);

        await _userInfo.setToken(token);
        await _userInfo.setUserID(user.id);

        print('Login successful, token saved'); // Debug log

        return {
          'success': true,
          'message': data['message'],
          'user': user,
          'token': token,
        };
      } else {
        print('Login failed with status: ${response.statusCode}'); // Debug log
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } on SocketException catch (e) {
      print('Socket exception during login: $e'); // Debug log
      return {'success': false, 'message': 'No internet connection'};
    } catch (e) {
      print('Exception during login: $e'); // Debug log
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  /// Logout user
  Future<Map<String, dynamic>> logout() async {
    try {
      final token = await _userInfo.getToken();

      if (token == null) {
        return {'success': false, 'message': 'No active session'};
      }

      final response = await http.post(
        Uri.parse(ApiUrl.logout),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
      );

      // Clear local session regardless of API response
      await _userInfo.logout();

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Logged out successfully'};
      } else {
        return {
          'success': true, // Still success because we cleared local data
          'message': 'Logged out locally',
        };
      }
    } catch (e) {
      // Clear local session even if API call fails
      await _userInfo.logout();
      return {'success': true, 'message': 'Logged out locally'};
    }
  }

  /// Get user profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await _userInfo.getToken();

      if (token == null) {
        return {'success': false, 'message': 'No active session'};
      }

      print('Getting profile with token: ${token.substring(0, 10)}...'); // Debug log (partial token)

      final response = await http.get(
        Uri.parse(ApiUrl.profile),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
      );

      print('Profile response status: ${response.statusCode}'); // Debug log
      print('Profile response body: ${response.body}'); // Debug log

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final user = User.fromJson(data['data']);
        print('Profile retrieved successfully for user: ${user.name}'); // Debug log
        return {'success': true, 'user': user};
      } else {
        print('Failed to get profile: ${data['message']}'); // Debug log
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get profile',
        };
      }
    } on SocketException catch (e) {
      print('Socket exception during profile fetch: $e'); // Debug log
      return {'success': false, 'message': 'No internet connection'};
    } catch (e) {
      print('Exception during profile fetch: $e'); // Debug log
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final token = await _userInfo.getToken();
      final userId = await _userInfo.getUserID();
      
      print('Checking login status - Token exists: ${token != null}, User ID exists: ${userId != null}'); // Debug log
      
      return token != null && token.isNotEmpty && userId != null;
    } catch (e) {
      print('Error checking login status: $e'); // Debug log
      return false;
    }
  }

  /// Get current user ID
  Future<int?> getCurrentUserId() async {
    return await _userInfo.getUserID();
  }

  /// Get current token
  Future<String?> getCurrentToken() async {
    return await _userInfo.getToken();
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    String? email,
    String? phone,
    String? profileBio,
  }) async {
    try {
      final token = await _userInfo.getToken();

      if (token == null) {
        return {'success': false, 'message': 'No active session'};
      }

      final body = {
        'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (profileBio != null) 'profile_bio': profileBio,
      };

      final response = await http.put(
        Uri.parse(ApiUrl.updateProfile),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        body: body,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final user = User.fromJson(data['data']);
        return {
          'success': true,
          'message': data['message'] ?? 'Profile updated successfully',
          'user': user,
        };
      } else {
        String errorMessage = data['message'] ?? 'Failed to update profile';
        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          errorMessage = errors.values.first[0];
        }

        return {'success': false, 'message': errorMessage};
      }
    } on SocketException {
      return {'success': false, 'message': 'No internet connection'};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  /// Change user password
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final token = await _userInfo.getToken();

      if (token == null) {
        return {'success': false, 'message': 'No active session'};
      }

      final response = await http.post(
        Uri.parse(ApiUrl.changePassword),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        body: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Password changed successfully',
        };
      } else {
        String errorMessage = data['message'] ?? 'Failed to change password';
        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          errorMessage = errors.values.first[0];
        }

        return {'success': false, 'message': errorMessage};
      }
    } on SocketException {
      return {'success': false, 'message': 'No internet connection'};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }
}
