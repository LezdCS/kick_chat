import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:kick_chat/src/entities/kick_user.dart';
import 'package:ua_client_hints/ua_client_hints.dart';

class KickApi {
  static final Logger _logger = Logger('KickApi');
  static Future<KickUser?> getUserDetails(
    String username,
  ) async {
    _logger.info('Fetching user details for username: $username');
    Response response;
    var dio = Dio();

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        dio.options.headers.addAll(await userAgentClientHintsHeader());
      }
      response = await dio.get(
        "https://kick.com/api/v2/channels/$username",
      );
      _logger.fine('Successfully retrieved user details from API');
      return KickUser.fromJson(response.data);
    } on DioException catch (e, stackTrace) {
      _logger.severe(
        'Failed to fetch user details for username: $username',
        e,
        stackTrace,
      );
      if (e.response != null) {
        _logger.warning(
          'API returned status ${e.response?.statusCode}: ${e.response?.data}',
        );
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        _logger.warning('Network timeout while fetching user details');
      } else if (e.type == DioExceptionType.connectionError) {
        _logger.warning('Connection error while fetching user details');
      }
      return null;
    } catch (e, stackTrace) {
      _logger.severe(
        'Unexpected error while fetching user details for username: $username',
        e,
        stackTrace,
      );
      return null;
    }
  }
}
