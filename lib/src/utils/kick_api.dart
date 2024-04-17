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
      String userAgent = '';
      if(Platform.isAndroid){
        userAgent = FkUserAgent.webViewUserAgent ?? '';
      } else if (Platform.isIOS){
        userAgent = FkUserAgent.webViewUserAgent ?? '';
      } else if (Platform.isLinux){
        userAgent = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:15.0) Gecko/20100101 Firefox/15.0.1';
      } else if (Platform.isMacOS){
        userAgent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko)';
      } else if (Platform.isWindows){
        userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko)';
      } else if (Platform.isFuchsia){
        userAgent = 'Mozilla/5.0 (X11; CrOS x86_64 8172.45.0) AppleWebKit/537.36 (KHTML, like Gecko)';
      }
      dio.options.headers['User-Agent'] = userAgent;
      response = await dio.get(
        "https://kick.com/api/v2/channels/$username",
      );
      return KickUser.fromJson(jsonDecode(response.data)) ;
    } on DioException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
