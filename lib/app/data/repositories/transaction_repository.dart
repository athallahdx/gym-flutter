import 'dart:convert';
import 'package:gym_app/app/core/providers/api_provider.dart';
import 'package:gym_app/app/core/providers/api_routes.dart';
import 'package:gym_app/app/data/models/transaction.dart';

class TransactionRepository {
  final Api _api = Api();

  Future<List<Transaction>> getTransactions() async {
    try {
      final response = await _api.get(ApiUrl.myTransactions);
      final jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        List<dynamic> transactionsData;

        if (jsonData['data'] is Map) {
          final dataMap = jsonData['data'] as Map<String, dynamic>;
          if (dataMap.containsKey('data')) {
            transactionsData = dataMap['data'] as List<dynamic>;
          } else if (dataMap.containsKey('transactions')) {
            transactionsData = dataMap['transactions'] as List<dynamic>;
          } else {
            transactionsData = [jsonData['data']];
          }
        } else if (jsonData['data'] is List) {
          transactionsData = jsonData['data'];
        } else if (jsonData is List) {
          transactionsData = jsonData;
        } else {
          throw Exception('Unexpected API response structure');
        }

        return transactionsData
            .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      rethrow;
    }
  }
}