import 'dart:convert';
import 'package:gym_app/app/core/providers/api_provider.dart';
import 'package:gym_app/app/core/providers/api_routes.dart';
import 'package:gym_app/app/data/models/gym_class.dart';
import 'package:gym_app/app/data/models/gym_class_detail.dart';

class GymclassRepository {
  final Api _api = Api();

  Future<List<GymClass>> getGymClasses() async {
    try {
      print (
        '🏋️‍♂️ Fetching gym classes from: ${ApiUrl.gymClasses}',
      );
      final response = await _api.get(ApiUrl.gymClasses);

      print('🏋️‍♂️ Response status: ${response.statusCode}');
      print('🏋️‍♂️ Response body: ${response.body}');

      if(response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        List<dynamic> classesData;

        if(jsonData['data'] is Map) {
          final dataMap = jsonData['data'] as Map<String, dynamic>;
          if(dataMap.containsKey('data')) {
            classesData = dataMap['data'] as List<dynamic>;
          } else if (dataMap.containsKey('classes')) {
            classesData = dataMap['classes'] as List<dynamic>;
          } else {
            classesData = [jsonData['data']];
          }
        } else if (jsonData['data'] is List) {
          classesData = jsonData['data'];
        } else if (jsonData is List) {
          classesData = jsonData;
        } else {
          print('🏋️‍♂️ Unexpected response structure: ${jsonData.runtimeType}');
          throw Exception('Unexpected API response structure');
        }

        return classesData.map((classJson) => GymClass.fromJson(classJson)).toList();
      } else {
        throw Exception('Failed to load gym classes: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching gym classes: $e');
      rethrow;
    }
  }

  Future<GymClassDetail> getGymClassById(int id) async {
    try {
      print('🏋️‍♂️ Fetching gym class detail for ID: $id');
      final response = await _api.get(ApiUrl.gymClassDetail(id));

      print('🏋️‍♂️ Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        // Handle response structure
        Map<String, dynamic> classData;
        if (jsonData['data'] is Map) {
          classData = jsonData['data'] as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected API response structure');
        }

        return GymClassDetail.fromJson(classData);
      } else {
        throw Exception('Failed to load gym class: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching gym class detail: $e');
      rethrow;
    }
  }
}