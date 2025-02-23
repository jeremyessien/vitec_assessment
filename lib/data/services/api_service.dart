import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:vitec_assessment/config/constants.dart';
import 'package:vitec_assessment/core/error/exceptions.dart';
import 'dart:developer' as dev;
import '../models/route_model.dart';

class ApiService {
  final Dio dio;
  final String baseUrl = AppConstants.baseUrl;

  ApiService() : dio = Dio() {
    dio.options.headers['Authorization'] = 'Basic dml0ZWNkZXY6bFRFUWNJNGJuUGcz';
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<List<RouteModel>> getRoutes() async {
    try {
      dev.log('Fetching routes from API', name: 'API');
      final response = await dio.get('$baseUrl/getRoutes.php');

      dev.log('API response status: ${response.statusCode}', name: 'API');

      if (response.statusCode == 200) {
        try {
          final String responseString = response.data;
          final Map<String, dynamic> responseData = json.decode(responseString);

          dev.log('Successfully parsed JSON string to Map', name: 'API_DEBUG');

          if (responseData['status'] == true &&
              responseData.containsKey('data')) {
            final data = responseData['data'] as Map<String, dynamic>;

            List<RouteModel> allRoutes = [];

            if (data.containsKey('nearby') && data['nearby'] is List) {
              final nearbyRoutes = (data['nearby'] as List)
                  .map((routeJson) => RouteModel.fromJson(routeJson))
                  .toList();
              allRoutes.addAll(nearbyRoutes);
            }

            if (data.containsKey('popular') && data['popular'] is List) {
              final popularRoutes = (data['popular'] as List)
                  .map((routeJson) => RouteModel.fromJson(routeJson))
                  .toList();

              final nearbyIds = allRoutes.map((route) => route.id).toSet();
              final uniquePopularRoutes = popularRoutes
                  .where((route) => !nearbyIds.contains(route.id))
                  .toList();

              allRoutes.addAll(uniquePopularRoutes);
            }

            dev.log('Parsed ${allRoutes.length} routes successfully', name: 'API');
            return allRoutes;
          } else {
            throw ApiException(message: 'Unexpected API response structure');
          }
        } catch (e) {
          dev.log('Error parsing response data', name: 'API', error: e);
          throw ApiException(
            message: 'Failed to parse API response',
            error: e,
          );
        }
      } else {
        throw ServerException(
          message: 'Failed to load routes',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      dev.log('DioException occurred', name: 'API', error: e);
      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      dev.log('Error in getRoutes', name: 'API', error: e);
      throw ApiException(
        message: 'Error fetching routes',
        error: e,
      );
    }
  }
}