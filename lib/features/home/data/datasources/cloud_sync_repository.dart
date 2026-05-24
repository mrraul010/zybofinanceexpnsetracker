import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:zyboexpensetracker/core/network/api_client.dart';

class CloudSyncRepository {
  final ApiClient _apiClient;

  CloudSyncRepository(this._apiClient);

  Future<bool> clearCloudDeletions(
    String relativeUrl,
    List<String> identifierList,
  ) async {
    if (identifierList.isEmpty) return true;
    try {
      final response = await _apiClient.delete(
        relativeUrl,
        data: {"ids": identifierList},
      );

      return response.data['status'] == 'success';
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        developer.log(
          'API NOTE: Items already gone from server (404). Proceeding.',
          name: 'SyncRepo',
        );
        return true;
      }
      developer.log(
        'API ERROR: Purge failed on $relativeUrl. Msg: ${e.message}',
        name: 'SyncRepo',
      );
      return false;
    }
  }

  Future<List<String>> transmitCategories(
    List<Map<String, dynamic>> structuralList,
  ) async {
    final List<String> processedIds = [];

    for (var categoryNode in structuralList) {
      try {
        final response = await _apiClient.post(
          '/categories/add/',
          data: {
            "category_id": categoryNode['id'],
            "name": categoryNode['name'],
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          processedIds.add(categoryNode['id'] as String);
        }
      } on DioException catch (e) {
        developer.log(
          'API ERROR: Category sync failed: ${e.message}',
          name: 'SyncRepo',
        );
      }
    }
    return processedIds;
  }

  Future<List<String>> transmitTransactions(
    List<Map<String, dynamic>> structuralList,
  ) async {
    if (structuralList.isEmpty) return [];

    try {
      final List<Map<String, dynamic>> mappedPayloadArray = structuralList.map((
        row,
      ) {
        String isoString = row['timestamp'].toString().replaceAll(' ', 'T');
        if (!isoString.contains('Z') && !isoString.contains('+')) {
          isoString += 'Z';
        }

        return {
          "id": row['id'],
          "amount": (row['amount'] as num).toDouble(),
          "note": row['note'] ?? 'Expense Entry',
          "type": row['type'],
          "category_id": row['category_id'],
          "timestamp": isoString,
        };
      }).toList();

      final response = await _apiClient.post(
        '/transactions/add/',
        data: {"transactions": mappedPayloadArray},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return List<String>.from(response.data['synced_ids'] ?? []);
      }
      return [];
    } on DioException catch (e) {
      developer.log(
        'API ERROR: Transactions batch sync failed: ${e.message}',
        name: 'SyncRepo',
      );
      return [];
    }
  }
}
