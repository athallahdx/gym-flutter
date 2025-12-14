import 'dart:convert';
import 'package:gym_app/app/core/providers/api_provider.dart';
import 'package:gym_app/app/core/providers/api_routes.dart';

class DashboardRepository {
  final Api _api = Api();

  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      print('🔄 Fetching dashboard data from: ${ApiUrl.dashboard}');

      final response = await _api.get(ApiUrl.dashboard);

      print('📊 Response status: ${response.statusCode}');
      print('📄 Response body (first 500 chars): ${response.body}');

      final jsonData = json.decode(response.body) as Map<String, dynamic>;

      print('✅ Dashboard data fetched successfully');
      return jsonData;
    } catch (e) {
      print('❌ Dashboard repository error: $e');
      rethrow;
    }
  }
}
