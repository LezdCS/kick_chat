import 'dart:convert';

import 'package:kick_chat/src/kick_event.dart';

class KickGiftedSubscriptions extends KickEvent {
  final Data data;

  KickGiftedSubscriptions({
    required super.event,
    required this.data,
    required super.channel,
  });

  factory KickGiftedSubscriptions.fromJson(Map<String, dynamic> map) {
    return KickGiftedSubscriptions(
      event: TypeEvent.followersUpdated,
      data: Data.fromJson(jsonDecode(map['data'])),
      channel: map['channel'],
    );
  }

  @override
  String toString() {
    return 'event: $event, data: $data, channel: $channel';
  }
}

class Data {
  final int chatroomId;
  final List<String> giftedUsernames;
  final String gifterUsername;

  Data({
    required this.chatroomId,
    required this.giftedUsernames,
    required this.gifterUsername,
  });

  factory Data.fromJson(Map<String, dynamic> map) {
    return Data(
      chatroomId: map['chatroomId'],
      giftedUsernames: map['gifted_usernames'],
      gifterUsername: map['gifter_username'],
    );
  }

  @override
  String toString() {
    return 'chatroomId: $chatroomId, giftedUsernames: $giftedUsernames, gifterUsername: $gifterUsername';
  }
}