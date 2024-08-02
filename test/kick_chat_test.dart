import 'package:api_7tv/api_7tv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kick_chat/kick_chat.dart';

void main() {
  String username = 'xqc';
  test('Listen to a Kick chat', () async {
    KickChat chat = KickChat(username, '32cbd69e4b950bf97679');
    chat.connect();
    chat.chatStream.listen((message) {
      final KickEvent? kickEvent = eventParser(message);
      if (kickEvent?.event == TypeEvent.message) {
        if (kDebugMode) {
          print(kickEvent as KickMessage);
        }
      }
    });
    await Future.delayed(const Duration(seconds: 300), () {});
  }, timeout: const Timeout.factor(20));
  test('Get channel user details', () async {
    WidgetsFlutterBinding.ensureInitialized();
    await KickChat.init();
    KickUser? userDetails = await KickApi.getUserDetails('xqc');
    expect(668, userDetails?.id);
  });

  test('Get 7TV Kick channel emotes', () async {
    WidgetsFlutterBinding.ensureInitialized();
    await KickChat.init();
    KickUser? userDetails = await KickApi.getUserDetails('xqc');
    if(userDetails == null) throw Exception('User details not found');
    List? emotes = await SeventvApi.getKickChannelEmotes(userDetails.userId.toString()) ?? [];
    debugPrint(emotes.length.toString());
    expect(emotes.length, greaterThanOrEqualTo(1));
  });
}
