import 'dart:developer';

import 'package:vitec_assessment/data/services/api_service.dart';

import '../models/route_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class RoutesRepository {
  final ApiService apiService;
  final FlutterSecureStorage storage;
  final String cacheKey = 'routes_cache';
  final String timestampKey = 'routes_timestamp';
  final Duration cacheValidity = const Duration(minutes: 1);

  RoutesRepository({
    required this.apiService,
    required this.storage,
  });

  Future<List<RouteModel>> getRoutes({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      log('Fetching data');
      final cachedData = await getCachedData();
      if (cachedData != null) {
        log('Cache datad length ${cachedData.length}');
        return cachedData;
      }
    }

    try {
      final routes = await apiService.getRoutes();
      await cacheData(routes);
      return routes;
    } catch (e) {

      final cachedData = await getCachedData(ignoreExpiry: true);
      if (cachedData != null) {
        return cachedData;
      }

      
      rethrow;
    }
  }



  Future<List<RouteModel>?> getCachedData({bool ignoreExpiry = false}) async {
    try {
      final cachedJson = await storage.read(key: cacheKey);
      final timestampStr = await storage.read(key: timestampKey);
      
      if (cachedJson == null || timestampStr == null) {
        return null;
      }
      
      if (!ignoreExpiry) {
        final timestamp = DateTime.parse(timestampStr);
        final now = DateTime.now();
        if (now.difference(timestamp) > cacheValidity) {
          return null;
        }
      }
      
      final List<dynamic> decoded = jsonDecode(cachedJson);
      return decoded.map((item) => RouteModel.fromJson(item)).toList();
    } catch (e) {
      return null; 
    }
  }

  Future<void> cacheData(List<RouteModel> routes) async {
    try {
      final jsonData = jsonEncode(routes.map((route) => route.toJson()).toList());
      await storage.write(key: cacheKey, value: jsonData);
      await storage.write(
        key: timestampKey,
        value: DateTime.now().toIso8601String(),
      );
    } catch (e) {
      log('Error caching data: $e');
    }
  }
}