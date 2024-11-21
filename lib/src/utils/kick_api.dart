import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kick_chat/src/entities/kick_user.dart';
import 'package:ua_client_hints/ua_client_hints.dart';

class KickApi {
  static Future<KickUser?> getUserDetails(
    String username,
  ) async {
    Response response;
    var dio = Dio();

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        dio.options.headers.addAll(await userAgentClientHintsHeader());
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
