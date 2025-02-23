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
      // Try to get from cache first
      log('Fetching data');
      final cachedData = await getCachedData();
      if (cachedData != null) {
        log('Cache datad length ${cachedData.length}');
        return cachedData;
      }
    }

    // If cache is invalid or forced refresh, fetch from API
    log('Invalid refresh, fetching from api');
    try {
      final routes = await apiService.getRoutes();
      log('Successfully fetched ${routes.length} routes from API');
      // Cache the fresh data
      await _cacheData(routes);
      return routes;
    } catch (e) {
      // If API fails but we have cached data, return that
      log('API fetch failed, checking for cache fallback', error: e);
      final cachedData = await getCachedData(ignoreExpiry: true);
      if (cachedData != null) {
        log('Returning ${cachedData.length} routes from cache as fallback');
        return cachedData;
      }

      
      // Otherwise, propagate the error
      rethrow;
    }
  }

  // List<RouteModel> _getDummyData() {
  //   return [
  //     RouteModel(
  //       id: 'dummy1',
  //       location: 'Surat',
  //       origin: 'Rangpur',
  //       countryCode: 'DE',
  //       imageUrl: 'https://picsum.photos/300/200',
  //       distance: 3.2,
  //       duration: 2.5,
  //       rating: 4.7,
  //     ),
  //     RouteModel(
  //       id: 'dummy2',
  //       location: 'Surat',
  //       origin: 'Rangpur',
  //       countryCode: 'US',
  //       imageUrl: 'https://picsum.photos/300/201',
  //       distance: 4.1,
  //       duration: 3.5,
  //       rating: 4.8,
  //     ),
  //     RouteModel(
  //       id: 'dummy3',
  //       location: 'Surat',
  //       origin: 'Rangpur',
  //       countryCode: 'GB',
  //       imageUrl: 'https://picsum.photos/300/202',
  //       distance: 2.8,
  //       duration: 2.0,
  //       rating: 4.5,
  //     ),
  //     RouteModel(
  //       id: 'dummy4',
  //       location: 'Surat',
  //       origin: 'Rangpur',
  //       countryCode: 'DE',
  //       imageUrl: 'https://picsum.photos/300/203',
  //       distance: 3.7,
  //       duration: 2.8,
  //       rating: 4.6,
  //     ),
  //   ];
  // }


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
          return null; // Cache expired
        }
      }
      
      final List<dynamic> decoded = jsonDecode(cachedJson);
      return decoded.map((item) => RouteModel.fromJson(item)).toList();
    } catch (e) {
      return null; // Error reading cache
    }
  }

  Future<void> _cacheData(List<RouteModel> routes) async {
    try {
      final jsonData = jsonEncode(routes.map((route) => route.toJson()).toList());
      await storage.write(key: cacheKey, value: jsonData);
      await storage.write(
        key: timestampKey,
        value: DateTime.now().toIso8601String(),
      );
    } catch (e) {
      // Silently fail if caching has an issue
      log('Error caching data: $e');
    }
  }
}