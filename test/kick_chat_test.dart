import 'dart:async';

import 'package:api_7tv/api_7tv.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kick_chat/kick_chat.dart';

void main() {
  String username = 'Lezd';
  test('Listen to a Kick chat', () async {
    WidgetsFlutterBinding.ensureInitialized();
    KickChat.configureLogging(Level.ALL);
    await KickChat.init();
    KickChat chat = KickChat(username, '32cbd69e4b950bf97679');
    chat.connect();
    Completer<void> completer = Completer<void>();

    chat.chatStream.listen((KickEvent message) {
      if (message.event == TypeEvent.message) {
        debugPrint(message.toString());
        expect(true, isTrue, reason: 'A message event was received');
        // Complete the test successfully
        completer.complete();
      }
    });

    // Wait for the completer to complete
    await completer.future;
  }, timeout: const Timeout.factor(20));
  test('Get channel user details', () async {
    WidgetsFlutterBinding.ensureInitialized();
    KickChat.configureLogging(Level.ALL);
    await KickChat.init();
    KickUser? userDetails = await KickApi.getUserDetails(username);
    expect(username.toLowerCase(), userDetails?.slug,
        reason:
            'The username in lowercase should be the same as the user slug');
  });

  test('Get 7TV Kick channel emotes', () async {
    WidgetsFlutterBinding.ensureInitialized();
    KickChat.configureLogging(Level.ALL);
    await KickChat.init();
    KickUser? userDetails = await KickApi.getUserDetails(username);
    if (userDetails == null) throw Exception('User details not found');
    List? emotes =
        await SeventvApi.getKickChannelEmotes(userDetails.userId.toString()) ??
            [];
    debugPrint(emotes.length.toString());
    expect(emotes.length, greaterThanOrEqualTo(1),
        reason: 'The emotes should be greater than or equal to 1');
  });
}
