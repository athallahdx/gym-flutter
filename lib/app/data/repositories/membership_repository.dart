import 'dart:convert';
import 'package:gym_app/app/data/models/membership_package.dart';
import 'package:gym_app/app/data/providers/api_provider.dart';
import 'package:gym_app/app/data/providers/api_routes.dart';

class MembershipRepository {
  final Api _api = Api();

  /// Fetch all membership packages (public endpoint)
  Future<List<MembershipPackage>> getMembershipPackages() async {
    try {
      print(
        '📦 Fetching membership packages from: ${ApiUrl.membershipPackages}',
      );
      final response = await _api.get(ApiUrl.membershipPackages);

      print('📦 Response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Handle paginated response: { "data": { "data": [...] } }
        List<dynamic> packagesData;

        if (jsonData['data'] is Map) {
          final dataMap = jsonData['data'] as Map<String, dynamic>;
          if (dataMap.containsKey('data')) {
            // Paginated response
            packagesData = dataMap['data'] as List<dynamic>;
          } else if (dataMap.containsKey('packages')) {
            packagesData = dataMap['packages'] as List<dynamic>;
          } else {
            packagesData = [jsonData['data']];
          }
        } else if (jsonData['data'] is List) {
          packagesData = jsonData['data'];
        } else if (jsonData is List) {
          packagesData = jsonData;
        } else {
          print('📦 Unexpected response structure: ${jsonData.runtimeType}');
          throw Exception('Unexpected API response structure');
        }

        print('📦 Found ${packagesData.length} packages');

        return packagesData
            .map(
              (json) =>
                  MembershipPackage.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception('Failed to load membership packages');
      }
    } catch (e) {
      print('❌ Error fetching membership packages: $e');
      rethrow;
    }
  }

  /// Fetch single membership package details
  Future<MembershipPackage> getMembershipPackageDetail(int id) async {
    try {
      final response = await _api.get(ApiUrl.membershipPackageDetail(id));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MembershipPackage.fromJson(jsonData['data']);
      } else {
        throw Exception('Failed to load membership package details');
      }
    } catch (e) {
      throw Exception('Error fetching membership package details: $e');
    }
  }

  /// Purchase a membership package (protected endpoint)
  Future<Map<String, dynamic>> purchaseMembership(String packageId) async {
    try {
      final response = await _api.post(
        ApiUrl.purchaseMembership,
        json.encode({'package_id': packageId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to purchase membership');
      }
    } catch (e) {
      throw Exception('Error purchasing membership: $e');
    }
  }

  /// Get user's current active membership
  Future<Map<String, dynamic>?> getCurrentMembership() async {
    try {
      print('🎫 Fetching current membership from: ${ApiUrl.currentMembership}');
      final response = await _api.get(ApiUrl.currentMembership);

      print('🎫 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('🎫 Current membership found');
        return jsonData['data'];
      } else if (response.statusCode == 404) {
        print('🎫 No active membership found (404)');
        return null; // No active membership
      } else {
        print('🎫 Unexpected status code: ${response.statusCode}');
        throw Exception('Failed to load current membership');
      }
    } catch (e) {
      print('❌ Error fetching current membership: $e');
      // Return null instead of throwing error to avoid blocking package loading
      return null;
    }
  }
}
