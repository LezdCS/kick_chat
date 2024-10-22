import 'package:api_7tv/api_7tv.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kick_chat/kick_chat.dart';

void main() {
  String username = 'Lezd';
  test('Listen to a Kick chat', () async {
    KickChat chat = KickChat(username, '32cbd69e4b950bf97679');
    chat.connect();
    chat.chatStream.listen((KickEvent message) {
      if (message.event == TypeEvent.message) {
        expect("chatrooms.${chat.userDetails?.chatRoom.id}.v2", message.channel, reason: 'The channel should be the same as the message channel');
      }
    });
    await Future.delayed(const Duration(seconds: 300), () {});
  }, timeout: const Timeout.factor(20));
  test('Get channel user details', () async {
    WidgetsFlutterBinding.ensureInitialized();
    await KickChat.init();
    KickUser? userDetails = await KickApi.getUserDetails(username);
    expect(username.toLowerCase(), userDetails?.slug, reason: 'The username in lowercase should be the same as the user slug');
  });

  test('Get 7TV Kick channel emotes', () async {
    WidgetsFlutterBinding.ensureInitialized();
    await KickChat.init();
    KickUser? userDetails = await KickApi.getUserDetails(username);
    if(userDetails == null) throw Exception('User details not found');
    List? emotes = await SeventvApi.getKickChannelEmotes(userDetails.userId.toString()) ?? [];
    debugPrint(emotes.length.toString());
    expect(emotes.length, greaterThanOrEqualTo(1), reason: 'The emotes should be greater than or equal to 1');
  });
}
