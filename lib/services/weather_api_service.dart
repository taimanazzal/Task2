import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../core/network/api_exceptions.dart';
import '../models/weather_model.dart';

class WeatherApiService {
  final Dio _dio = DioClient.instance;
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<WeatherModel> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'current':
              'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m,surface_pressure,uv_index,is_day',
          'hourly': 'temperature_2m,weather_code',
          'daily': 'temperature_2m_max,temperature_2m_min,weather_code',
          'timezone': 'auto',
          'forecast_days': 7,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(response.statusCode ?? 0);
      }

      return WeatherModel.fromJson(response.data);
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
