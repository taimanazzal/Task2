import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../core/network/api_exceptions.dart';
import '../models/city_model.dart';

class GeocodingApiService {
  final Dio _dio = DioClient.instance;
  static const String _baseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';

  Future<List<CityModel>> searchCities(String query) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'name': query,
          'count': 10,
          'language': 'ar',
          'format': 'json',
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(response.statusCode ?? 0);
      }

      final results = response.data['results'] as List?;

      if (results == null) {
        return [];
      }

      return results.map((json) => CityModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return TimeoutException();
      case DioExceptionType.connectionError:
        return NoInternetException();
      case DioExceptionType.badResponse:
        return ServerException(e.response?.statusCode ?? 0);
      default:
        return ApiException('حدث خطأ غير متوقع');
    }
  }
}
