import 'dart:convert';
import 'package:gym_app/app/core/providers/api_provider.dart';
import 'package:gym_app/app/core/providers/api_routes.dart';

class DashboardRepository {
  final Api _api = Api();

  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final response = await _api.get(ApiUrl.dashboard);
      final jsonData = json.decode(response.body) as Map<String, dynamic>;


      return jsonData;
    } catch (e) {

      rethrow;
    }
  }
}
