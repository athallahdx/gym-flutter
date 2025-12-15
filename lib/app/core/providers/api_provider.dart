import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gym_app/app/core/services/user_info.dart';
import 'package:gym_app/app/core/errors/app_exception.dart';

class Api {
  Future<dynamic> post(dynamic url, dynamic data) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: data,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException catch (e) {
      print('🔌 SocketException: $e');
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print('❌ Unexpected error in POST: $e');
      throw FetchDataException('Error: $e');
    }
    return responseJson;
  }

  Future<dynamic> get(dynamic url) async {
    var token = await UserInfo().getToken();
    print(
      '🔑 Token (first 20 chars): ${token?.substring(0, token.length > 20 ? 20 : token.length)}...',
    );
    print('🌐 GET Request to: $url');
    var responseJson;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException catch (e) {
      print('🔌 SocketException: $e');
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print('❌ Unexpected error in GET: $e');
      throw FetchDataException('Error: $e');
    }
    return responseJson;
  }

  Future<dynamic> put(dynamic url, dynamic data) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final response = await http.put(
        Uri.parse(url),
        body: data,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException catch (e) {
      print('🔌 SocketException: $e');
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print('❌ Unexpected error in PUT: $e');
      throw FetchDataException('Error: $e');
    }
    return responseJson;
  }

  Future<dynamic> delete(dynamic url) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException catch (e) {
      print('🔌 SocketException: $e');
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print('❌ Unexpected error in DELETE: $e');
      throw FetchDataException('Error: $e');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        print('❌ Unauthorized - Token may be expired');
        throw UnauthorisedException(response.body.toString());
      case 422:
        throw InvalidInputException(response.body.toString());
      case 500:
        // Handle 500 error with specific message extraction
        String errorMessage = _extractErrorMessage(response.body);
        print('❌ Server Error (500): $errorMessage');
        throw FetchDataException(errorMessage);
      default:
        throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}\nBody: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}',
        );
    }
  }

  String _extractErrorMessage(String responseBody) {
    try {
      final jsonResponse = jsonDecode(responseBody);
      
      // Check if response contains a message about email verification
      if (jsonResponse is Map<String, dynamic>) {
        final message = jsonResponse['message'] ?? '';
        
        if (message.toLowerCase().contains('email') && 
            message.toLowerCase().contains('verif')) {
          return '📧 Your email is not verified.\n\nPlease check your email and verify your account to continue.';
        }
        
        // Return the server message if available
        if (message.isNotEmpty) {
          return message;
        }
      }
    } catch (e) {
      // If JSON parsing fails, continue with default message
      print('⚠️ Could not parse error response: $e');
    }
    
    // Default message
    return 'Server error occurred. Please try again later.';
  }
}
