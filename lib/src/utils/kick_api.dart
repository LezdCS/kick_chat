import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/foundation.dart';
import 'package:kick_chat/src/entities/kick_user.dart';

class KickApi {
  static Future<KickUser?> getUserDetails(
    String username,
  ) async {
    Response response;
    var dio = Dio();

    try {
      String? userAgent;
      if (Platform.isAndroid || Platform.isIOS) {
        userAgent = FkUserAgent.userAgent;
      }
      if (userAgent != null) {
        dio.options.headers['User-Agent'] = userAgent;
      }
      response = await dio.get(
        "https://kick.com/api/v2/channels/$username",
      );
      return KickUser.fromJson(jsonDecode(response.data));
    } on DioException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
